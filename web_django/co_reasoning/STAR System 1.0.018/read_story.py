import subprocess, re, json
import networkx as nx
import matplotlib.pyplot as plt

def select_story (story):
    print('You chose the story ' + story)
    saved_lines = []
    with open ('config.pl', 'r') as f:
        for line in f:
            if line.startswith('domain'):
                line = re.sub('domains/(.*)\.pl', 'domains/'+ story +'.pl', line)
            saved_lines.append(line.rstrip('\n'))
    f.close()

    with open('config.pl', 'w') as f:
        for line in saved_lines:
            f.write(line + '\n')
    f.close()

def form_aguments(text):
    acceptable_arguments = {}
    for j in range(len(text)):
        match_result = re.match(r'(.*) : (.*) @ (\d*) -(.)-> \((.*)\)', text[j])
        argument_id = match_result.group(1)
        argument = match_result.group(2)

        if argument.startswith('cau'):
            argument = re.match(r'cau\((.*),\[(.*)\]\)', argument)
        elif argument.startswith('pro'):
            argument = re.match(r'pro\((.*),\[(.*)\]\)', argument)
        #     else:
        #         print('Wrong start with the argument' + argument)
        argument = argument.group(2) + ','
        argument_list = [s + 'true' for s in argument.split('true,')]

        timestep = match_result.group(3)
        conclusion = match_result.group(5)
        conclusion = re.match(r'(.*),(\d*),(.*)', conclusion).group(1)
        if argument_id not in acceptable_arguments:
            acceptable_arguments[argument_id] = {}
            acceptable_arguments[argument_id]['argument'] = argument_list[:len(argument_list) - 1]
            acceptable_arguments[argument_id]['timestep'] = timestep
            acceptable_arguments[argument_id]['conclusion'] = conclusion
        elif timestep < acceptable_arguments[argument_id]['timestep']:
            acceptable_arguments[argument_id]['timestep'] = timestep

    return acceptable_arguments

def extract_reasoning_and_answer(lines):
    text = []
    qa = {}
    for i in range(len(lines)):
        if 'Answering question' in lines[i]:
            question = lines[i].split('Answering question ')[1].rstrip(':')
            match_answer = re.match(r'([-\?\+]) \w+ choice: ,\[(.*)at (.*)\]', lines[i + 1])
            if question not in qa:
                qa[question] = {'answer': match_answer.group(1), 'conclusion': match_answer.group(2),
                                'timestep': match_answer.group(3)}
            else:
                qa[question]['answer'] = match_answer.group(1)
        elif 'Acceptable argument' in lines[i] and lines[i + 1] != '':
            for j in range(i + 1, len(lines)):
                if '-f->' in lines[j] and 'per(p(' not in lines[j] and 'per(c(' not in lines[j] and 'per(o(' not in \
                        lines[j]:
                    text.append(lines[j])
                if 'Comprehension model' in lines[j + 1]:
                    break

    for question in qa:
        if qa[question]['answer'] == '+':
            qa[question]['conclusion'] += '=true'
        elif qa[question]['answer'] == '-':
            qa[question]['conclusion'] += '#true'

    acceptable_arguments = form_aguments(text)
    return acceptable_arguments, qa

def find_path(start_conclusion_list, time):
    for index in range(len(start_conclusion_list)):
        start_conclusion = start_conclusion_list[index]
        for ar in acceptable_arguments:
            if start_conclusion == acceptable_arguments[ar]['conclusion']:
                con = acceptable_arguments[ar]
                if time < con['timestep']:
                    for i in range(index):
                        node1 = start_conclusion_list[i]
                        for node2 in DG.predecessors(node1):
                            DG.remode_node(node2)
                    return True

                if DG.has_node(con['conclusion']) == False:
                    DG.add_node(con['conclusion'])

                premise_list = []
                for i in range(len(con['argument'])):
                    premise = con['argument'][i]
                    DG.add_node(premise)
                    DG.add_edge(premise, con['conclusion'], name=ar)
                    premise_list.append(premise)
                time_error = find_path(premise_list, time)
                if time_error == True:
                    for premise in premise_list:
                        DG.remove_node(premise)
                    return True

    return False

# Choose a story and change config.pl
story_list = ['doorbell', 'Example_Story', 'Forgetfulness_Case',
              'House_Adventure', 'lightson', 'Nighttime_Snack', 'papajoe',
             'penguins', 'surprise', 'Unpleasant_Surprise']

select_story(story_list[0])

# Run the system
print('Start reading the story... ...')
cmd = 'swipl -s engine.pl -g start -t halt'
cmd = cmd.split(' ')
result = subprocess.run(cmd, stdout=subprocess.PIPE)
print('Finish reading the story!')

# Extract reasoning and answer
lines = result.stdout.decode("utf-8").split('\n')
acceptable_arguments, qa = extract_reasoning_and_answer(lines)

# Saving acceptable_arguments and qa
with open ('acceptable_arguments.json', 'w') as f:
    json.dump(acceptable_arguments, f, indent=4)
f.close()
with open ('qa.json', 'w') as f:
    json.dump(qa, f, indent=4)
f.close()

# Output answers and reasoning
for i in range(len(qa)):
    DG = nx.DiGraph()
    start_con = qa['q(' + str(i+1) + ')']['conclusion']
    time = qa['q(' + str(i+1) + ')']['timestep']
    print('Answering q' + str(i+1))
    find_path([start_con], time)
    for n, nbrs in DG.adj.items():
        print(n, nbrs)
    nx.draw(DG, with_labels=True, font_weight='bold')
    break
