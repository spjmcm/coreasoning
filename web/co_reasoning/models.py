from django.db import models

# Create your models here.
class Story(models.Model):
    story_id = models.AutoField(primary_key=True)
    group_name = models.CharField(max_length=50)
    sen_1 = models.CharField(max_length=200)
    sen_2 = models.CharField(max_length=200)
    sen_3 = models.CharField(max_length=200)
    sen_4 = models.CharField(max_length=200)
    sne_5 = models.CharField(max_length=200)
    Q1 = models.CharField(max_length=200)
    Q2 = models.CharField(max_length=200, null=True)
