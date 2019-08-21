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
                                             password='zz498270958')
        cursor = connection.cursor(prepared=True)
        # sql_create_table = '''CREATE TABLE IF NOT EXISTS stories (
        # group_name VARCHAR(255),
        # sen_1 VARCHAR(255),
        # sen_2 VARCHAR(255),
        # sen_3 VARCHAR(255),
        # sen_4 VARCHAR(255),
        # sen_5 VARCHAR(255),
        # q1 VARCHAR(255),
        # q2 VARCHAR(255),
        # story_id int(11) not null auto_increment,
        # primary key (story_id)
        # )'''
        sql_insert_query = ''' INSERT INTO stories (group_name, sen_1, sen_2, sen_3, sen_4, sen_5, Q1, Q2) VALUES (%s, %s, %s, %s, %s, %s, %s)'''
        insert_tuple = (group_name, sentenses[0].strip(), sentenses[1].strip(), sentenses[2].strip(), sentenses[3].strip(), sentenses[4].strip(), question1, question2)
        # setup_table = cursor.execute(sql_create_table)
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
