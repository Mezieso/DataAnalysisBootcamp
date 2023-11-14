#!/usr/bin/env python
# coding: utf-8

# In[3]:


from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'5000',
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': 'a17643b4-8049-4100-8495-0fd6ff467a86',
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)


# In[7]:


type(data)


# In[4]:


import pandas as pd


# In[5]:


pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)


# In[6]:


df = pd.json_normalize(data['data'])
df['timestamp'] = pd.to_datetime('now')

df


# In[12]:


def api_runner():
    global df
    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    parameters = {
      'start':'1',
      'limit':'5000',
      'convert':'USD'
    }
    headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': 'a17643b4-8049-4100-8495-0fd6ff467a86',
    }

    session = Session()
    session.headers.update(headers)

    try:
      response = session.get(url, params=parameters)
      data = json.loads(response.text)
      print(data)
    except (ConnectionError, Timeout, TooManyRedirects) as e:
      print(e)
    
    
    
    
    df2 = pd.json_normalize(data['data'])
    df2['timestamp'] = pd.to_datetime('now')
    df = df.append(df2)


# In[13]:


import os
from time import time
from time import sleep

for i in range(333):
    api_runner()
    print('API Runner Completed')
    sleep(60)
exit()


# In[16]:


df72 = pd.read_csv(r"C:\Users\chiem\Documents\Data Analysis\Data Analysis Bootcamp\PYTHON\APIs for Crypto.csv")
df72


# In[ ]:




