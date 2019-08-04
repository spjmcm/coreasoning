import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode
import pandas as pd
import numpy as np

def insertRecord(group_name, story, question1, question2):
    #split a story into sentences
    sentenses = story.split('.')

    try:
        connection = mysql.connector.connect(host='localhost',
                                             database='story',
                                             user='zhengzhang',
                                             password='zz498270958',
                                             use_pure=True)
        cursor = connection.cursor(prepared=True)
        sql_insert_query = ''' INSERT INTO stories (group_name, sen_1, sen_2, sen_3, sen_4, sen_5, q1, q2) VALUES (%s, %s, %s, %s, %s, %s, %s)'''
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


df = pd.read_csv('stories.csv', header=0)
for i in range(len(df)):
    insertRecord(df.iloc[i]['Group'], df.iloc[i]['Story'], df.iloc[i]['Question1'], df.iloc[i]['Question2'])
