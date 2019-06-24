from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json, os


def index(request):
    return render(request, 'index.html')

@csrf_exempt
def get_dropped_data(request):
    # source is the node that needs to be added
    source = request.GET.get('source', None)
    target = request.GET.get('target', None)

    cwd = os.getcwd()
    with open (cwd + '/co_reasoning/static/tree_data/q(1).json', 'r') as f:
        qa_data = json.load(f)
    f.close()
    
    # Using dfs find target and add source into the tree
    dfs(qa_data, source, target)

    with open (cwd + '/co_reasoning/static/tree_data/q(1)_tmp.json', 'w') as f:
        json.dump(qa_data, f)
    f.close()
    return JsonResponse(qa_data)

def dfs(tree, source, target):
    if tree['id'] == target:
        if 'children' not in tree:
            tree['children'] = []
        tree['children'].append({'id': source})
        return True
    elif 'children' in tree:
        for children in tree['children']:
            result = dfs(children, source, target)
            if result:
                return True
    return False