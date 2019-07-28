import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

def insertRecord(group_name, story, question):
    #split a story into sentences
    sentenses = story.split('.')

    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='story',
                                             user='zhengzhang',
                                             password='zz498270958')
        cursor = connection.cursor(prepared=True)
        sql_insert_query = ''' INSERT INTO stories (group_name, sen_1, sen_2, sen_3, sen_4, sen_5, Q1) VALUES (%s, %s, %s, %s, %s, %s, %s)'''
        insert_tuple = (group_name, sentenses[0], sentenses[1], sentenses[2], sentenses[3], sentenses[4], question)
        result = cursor.execute(sql_insert_query, insert_tuple)
        connection.commit()
        print("Record inserted successfully into stories table")

    except Error as error:
        connection.rollback()
        print("Failed to insert into MySQL table {}".format(error))

    finally:
        if(connection.is_connected()):
            cursor.close()
            connection.close()
            print("MySQL connection is closed")

insertRecord('Group 1',
             'Teddy and his friends were playing videogames together. They decided to order pizza. They were all very hungry. They decided that Supreme pizzas offer the best value. They ordered supreme pizzas and were very happy.',
             'why were they happy?')

insertRecord('Group 1',
             'I was in a bad mood. At work, I yelled at people. It the bus stop, I screamed at a bird. I realized that I was simply hungry. After eating a pizza, I felt happy again.',
             'why were they happy?')