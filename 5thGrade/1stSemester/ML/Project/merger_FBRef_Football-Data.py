import pandas as pd

anos = ['201819','201920','202021','202122','202223']

from fuzzywuzzy import fuzz, process

def _find_best_match(team_name, team_name_list):
    # Use process.extractOne to find the best match
    return process.extract(team_name, team_name_list, limit=2)[0][0]

def team_name_mapping(original_team_names:list, replacement_team_names:list) -> dict:
    """
    Function to get the dict {original:replacement} for all teams.

    Parameters
    ----------
    original_team_names : [str] 
        should be a list of string of the original team names
    
    replacement_team_names : [str]
        should be a list of string of the team names to replace with

    Returns
    -------
    dict
        a dictionary where key it's original team name and value is the replacement name
    
    """
    team_name_mapping = {}
    for team_name in original_team_names:
        best_match = _find_best_match(team_name, replacement_team_names)
        if best_match:
            team_name_mapping[team_name] = best_match
    
    return team_name_mapping



for ano in anos:

    df = pd.read_csv(f'fbref/dataset_{ano}.csv')
    fd = pd.read_csv(f'football-data/{ano}.csv')

    conversao = team_name_mapping(df['home'].unique(), fd['HomeTeam'].unique())
    df['home'] = df['home'].replace(conversao)
    df['away'] = df['away'].replace(conversao)
     
    
    new_df = pd.merge(df, fd,  how='left', left_on=['home','away'], right_on = ['HomeTeam','AwayTeam'])
    new_df.drop(['HomeTeam', 'AwayTeam'], inplace=True, axis=1)
    
    new_df.to_csv(f'merged/merged_{ano}.csv',index=False)
    
df1 = pd.read_csv('merged/merged_201819.csv')
df2 = pd.read_csv('merged/merged_201920.csv')
df3 = pd.read_csv('merged/merged_202021.csv')
df4 = pd.read_csv('merged/merged_202122.csv')
df5 = pd.read_csv('merged/merged_202223.csv')

df1['season'] = 2019
df2['season'] = 2020
df3['season'] = 2021
df4['season'] = 2022
df5['season'] = 2023

df6 = pd.concat([df1,df2,df3,df4,df5])

df6.to_csv('merged_treinofinaltudo.csv', index=False)
    
'''
##### Descobrir as diferenças nos nomes das equipas entre ambos os datasets

a = [x for x in list(dict(zip(df['home'],fd['HomeTeam'])).keys()) if x not in list(conversao.keys())]
print(a)
'''
