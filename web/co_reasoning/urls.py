from django.urls import path
from django.conf.urls import url
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    url(r'^get_dropped_data/', views.get_dropped_data, name='get_dropped')
]