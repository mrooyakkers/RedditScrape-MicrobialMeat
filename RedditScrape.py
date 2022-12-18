import praw
reddit = praw.Reddit(client_id='x', client_secret='x', user_agent='x')

# wheresthebeef
submission = reddit.submission(url="https://www.reddit.com/r/wheresthebeef/comments/xjmt3x/what_types_of_meat_do_you_want_designed/")
    
wheresthebeef = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    wheresthebeef.append(cur)

# wheresthebeef2
submission = reddit.submission(url="https://www.reddit.com/r/wheresthebeef/comments/mqrxbq/new_subscribers_introduce_yourself_here/")

wheresthebeef2 = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    wheresthebeef2.append(cur)

# wheresthebeef3
submission = reddit.submission(url="https://www.reddit.com/r/wheresthebeef/comments/y1iuaf/most_vegans_support_labgrown_meat_but_wont_eat_it/")
    
wheresthebeef3 = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    wheresthebeef3.append(cur)

# technology
submission = reddit.submission(url="https://www.reddit.com/r/technology/comments/y6lt69/redefine_meat_strikes_partnership_to_boost/")
    
technology = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    technology.append(cur)

# IamA
submission = reddit.submission(url="https://www.reddit.com/r/IAmA/comments/qc51s7/we_are_new_harvest_the_cellular_agriculture/")
    
IamA = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    IamA.append(cur)

# vegan
submission = reddit.submission(url="https://www.reddit.com/r/vegan/comments/x491ku/do_you_consider_beyond_or_impossible_meats_as/")
    
vegan = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    vegan.append(cur)

# vegan2
submission = reddit.submission(url="https://www.reddit.com/r/vegan/comments/p32vf8/is_anyone_else_not_going_to_be_eaten_so_called/")
    
vegan2 = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    vegan2.append(cur)

# collapse
submission = reddit.submission(url="https://www.reddit.com/r/collapse/comments/s1nwxm/air_protein_and_microbegrown_food_should_be/")
    
collapse = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    collapse.append(cur)

# collapse2
submission = reddit.submission(url="https://www.reddit.com/r/collapse/comments/v2mgho/replacing_some_meat_with_microbial_protein_could/")
    
collapse2 = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    collapse2.append(cur)

# science
submission = reddit.submission(url="https://www.reddit.com/r/science/comments/ui8z8z/swapping_20_of_beef_for_microbial_protein_like/")
    
science = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    science.append(cur)

# future
submission = reddit.submission(url="https://www.reddit.com/r/Futurology/comments/uke9fv/a_californian_company_is_selling_real_dairy/")
    
future = []
for top_level_comment in submission.comments:
    cur = str(top_level_comment.body)
    future.append(cur)

import pandas as pd
 
# initialize data of lists.
data = {'future': future,
        'wheresthebeef': wheresthebeef,
        'wheresthebeef2': wheresthebeef2,
        'wheresthebeef3': wheresthebeef3,
        'technology': technology,
        'IamA': IamA,
        'vegan': vegan,
        'vegan2': vegan2,
        'collapse': collapse,
        'collapse2': collapse2,
        'science': science,
        }
 
# Create DataFrame
df = pd.DataFrame(data)

#save 
df.to_csv("reddit_data.csv")
