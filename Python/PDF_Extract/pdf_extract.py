#%%
# Import the pymypdf module and open a PDF file
import pymupdf as pdf
import pandas as pd
import numpy as np

# Open pdf file
f = '../List of countries by GDP.pdf'
doc = pdf.open(f)


# %%
print(doc.metadata)


# %%
pdf.find_tables(doc)
# %%

# empty dataframe to store tables
tables = pd.DataFrame()

# Loop through each page in the PDF file
for page in doc[1:6]:
    # Extract table from each page
    table_found = page.find_tables()[0]
    table = table_found.extract()
    # Convert table to a pandas dataframe
    df = pd.DataFrame(table)
    # Append to the tables dataframe
    tables = pd.concat([tables, df])


# %%
tables.columns = ['position','Country', 'GDP_IMF_fcast', 'IMF_year', 
                  'GDP_WB_fcast', 'WB_year', 'GDP_UN_fcast', 'UN_year']

# %%
tables
# %%

# Table cleanup
tables.drop([0,1], axis=0, inplace=True)
tables.replace('.n\s\d.', '', regex=True, inplace=True)
tables.replace('IMF[1][13]', '', regex=True, inplace=True)
tables.replace('Forecast', '', regex=True, inplace=True)
tables.replace(',', '', inplace=True)
tables.replace('—', '', inplace=True)
tables.replace('', np.nan, inplace=True)
tables.fillna(np.nan, inplace=True)

# %%
tables[['GDP_IMF_fcast', 'GDP_WB_fcast','GDP_UN_fcast']] = tables[['GDP_IMF_fcast', 'GDP_WB_fcast','GDP_UN_fcast']].astype(float)
tables[['IMF_year', 'WB_year','UN_year']] = tables[['GDP_IMF_fcast', 'GDP_WB_fcast','GDP_UN_fcast']].astype(int)
tables.dtypes

#%%
tables.to_csv('../countries_gdp.csv', index=False)

