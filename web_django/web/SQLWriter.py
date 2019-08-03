import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

def insertRecord(group_name, story, question1, question2):
    #split a story into sentences
    sentenses = story.split('.')

    try:
        connection = mysql.connector.connect(host='47.252.82.40',
                                             database='story',
                                             user='zhengzhang',
                                             password='zz498270958')
        cursor = connection.cursor(prepared=True)
        sql_insert_query = ''' INSERT INTO stories (group_name, sen_1, sen_2, sen_3, sen_4, sen_5, Q1, Q2) VALUES (%s, %s, %s, %s, %s, %s, %s)'''
        insert_tuple = (group_name, sentenses[0], sentenses[1], sentenses[2], sentenses[3], sentenses[4], question1, question2)
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
             'Bryan was trying to do his homework, but his dogs were barking. His dogs were hungry and they had no food. Bryan was forced to go out and buy food. Bryan bought food in bulk for his dogs. The dogs were happy and let Brian do his work.',
             'why were the dogs happy?',
             'why did Bryan need to buy food?')
