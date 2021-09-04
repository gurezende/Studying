import seaborn as sns
import numpy as np
import pandas as pd
import streamlit as st
import plotly.express as px

# Set Page Layout
st.set_page_config(layout='wide')

#-----------------------------------------------------------------------
# Load the Dataset
df = sns.load_dataset('tips')

# Add Lat Long
latlong = {'NY': {'lat': 40.730610, 'lon': -73.935242},
           'London': {'lat': 51.509865,'lon': -0.118092},
           'Paris': {'lat': 48.864716, 'lon':2.349014},
           'Sao Paulo': {'lat': -23.533773,'lon': -46.625290},
           'Rome': {'lat': 41.902782,'lon': 12.496366}
           }

city = ['Paris', 'London', 'NY', 'Sao Paulo', 'Rome']
np.random.seed(12)
city_random = np.random.choice(city, 244)

# Add Cols
df['city'] = city_random
df['lat'] = [latlong[city]['lat'] for city in city_random]
df['lon'] = [latlong[city]['lon'] for city in city_random]

#-----------------------------------------------------------------------

# SIDEBAR
# Let's add some functionalities in a sidebar

st.sidebar.subheader('Select to Filter the data')

# By Sex
st.sidebar.text('By Sex')
filter_sex = st.sidebar.radio('Filter By Sex', options=['Both', 'Female', 'Male'])
if filter_sex == 'Both':
    pass
else:
    df = df.query('sex == @filter_sex')

# By City
st.sidebar.text('By City')
filter_city = st.sidebar.multiselect('Filter By City', options=city, default=city)
df = df.query('city in @filter_city')


# About Me
st.sidebar.text('Demonstration App created with the toy dataset *Tips* from seaborn')
st.sidebar.text('App created by Gustavo R Santos')
st.sidebar.markdown('[Check out my blog on Medium](https://medium.com/gustavorsantos)')

#-----------------------------------------------------------------------

# Title
st.title('Restaurants Dashboard')

# Subheader
st.subheader('A quick view of the ***Good Meal*** restaurants around the world.')
st.subheader('| About Us')
# Another way to write text
"""
The *Good Meal* restaurants is an international chain founded in 2020 and currently present in 5 of the most important cities in the world: *NYC, São Paulo, London, Paris and Rome*.

"""

#Separator
st.markdown('---')

#-----------------------------------------------------------------------

# Columns Summary

st.subheader('| QUICK SUMMARY')

col1, col2, col3, col4 = st.columns(4)
# column 1
with col1:
    total = f'${int( df.total_bill.sum() ):,}'
    st.title(total)
    st.text('REVENUE')
# column 2
with col2:
    st.title(df.city.count())
    st.text('MEALS')
# column 3
with col3:
    st.title(df.size.sum())
    st.text('CLIENTS')
# column 4
with col4:
    st.title(df.city.nunique())
    st.text('CITIES')

#-----------------------------------------------------------------------

# Graphics
col1, col2, col3 = st.columns(3)
# column 1
with col1:
    ind1 = pd.DataFrame(df.groupby('sex').sex.count()).rename(columns={'sex':'count'}).reset_index()
    g1 = px.pie(ind1,
                values='count',
                names='sex',
                color='sex',
                color_discrete_map={'Male': 'royalblue','Female': 'pink'},
                title='| GENDER')
    g1.update_traces(textposition='inside',
                     textinfo='percent+label',
                     showlegend=False)
    st.plotly_chart(g1, use_container_width=True)

with col2:
    ind3 = pd.DataFrame(df.groupby('day').day.count()).rename(columns={'day':'count'}).reset_index()
    g3 = px.bar(ind3,
                x='day',
                y='count',
                title='| POPULAR DAYS')
    st.plotly_chart(g3, use_container_width=True)

with col3:
    ind2 = pd.DataFrame(df.groupby('time').time.count()).rename(columns={'time':'count'}).reset_index()
    g2 = px.pie(ind2,
                values='count',
                names='time',
                color='time',
                color_discrete_map={'Lunch': 'royalblue','Dinner': 'darkblue'},
                title='| POPULAR TIMES')
    g2.update_traces(textposition='inside',
                     textinfo='percent+label',
                     showlegend=False)
    st.plotly_chart(g2, use_container_width=True)

#-----------------------------------------------------------------------
st.subheader('| WHERE WE ARE MAKING MORE MONEY')
# Measurements
col1, col2 = st.columns(2)
# column 1 measurements
with col1:
    x = st.selectbox('Select the X Axis', options=df.columns, index=7)
# column 1 measurements
with col2:
    y = st.selectbox('Select the Y Axis', options=df.columns)

g4 = px.bar(df,
            x= x,
            y= y)
st.plotly_chart(g4, use_container_width=True)

#-----------------------------------------------------------------------

# Map
st.subheader('| WHERE ARE OUR RESTAURANTS')
df_map = df[['city','tip','lat', 'lon']]
st.map(df_map, zoom=2)

#-----------------------------------------------------------------------

