# Alpha-Draw
Ai Drawing IOS App


Team members:
  • Leonardo Nan
  • Yuanhao (Jeffery) Chai
  • Anthony (Erdong) Chen
  • Jennie Lu
  • Xinrui (katherine) Ge

Possible Functionality
1. Generate pictures and drawings based on user descriptions.
2. Generate pictures based on user drawings.
3. The Generate picture will be updated throughout the whole process in a span of 5 min.
4. Users will be able to share their pictures after the app finish drawing.


Product Analysis:
1. Demand analysis
  > Identify the target user and the user's needs. Why is an app like Alpha Draw needed? Why will people use it? What are the benefits of using it? What is the difference between running AI drawing on a PC and running it on a mobile phone?
2. Market Potential
  > Analyze the market potential of the product. What kind of users will use the APP? How might they be involved in the consumption of the APP? 
3. Competitor Analysis
  > Analyze the competitors of the product. What are their features? What particular part of our product could attract users?

**Brief for Demand analysis:**

>While most of the ai drawing model was written in python, and the generating process heavily relies on GPU, making it impossible to run on the mobile phone. Our APP Alpha Draw's goal is to resolve the limitation of the device used to run the AI model. We want to make the AI drawing model available to everyone and enable it to run anywhere, anytime. 

>After playing around with the current AI Arts APP, I found many functions still missing. Our essential role is to let the user draw a scratch image using their fingers or apple pencil in our built-in drawing function. Then the user could push their "artworks" to the cloud and let the backend server do the AI drawing, filling in the missing part of the image and improving. Then the database will return the generated image to the user. The user could then save the image to their phone or share it on social media.


# Replicate API:
https://replicate.com/
> We are using replicate API to serve as the actually server for running the AI text to image, image to image model.
> Authentication, GET/POST request, Decodable Structs, Input Parameters, Converting Swift input to JSON obj, Error Handling.

# DataBase
# Firebase & Google Drive
>We plan to use Firebase for our user backend. Not only because firebase have special support for IOS apps, but also reduce the time for developing backend server from scratch. Now, here’s some key function that need database to shine:

1. Image to image function
> Since API takes image url as input, we have to convert user’s drawing or uploaded image to our database and hold a image url in order to pass the parameter into the APIs.

2. Authentication:
> We are not making charity, but an APP that has its own environment that could live. We need to authenticate every user who use our app, the API is not free since running models takes a lot of GPU resources. Ideally, the we hold users information in Firebase including emails, payment, money, uploaded/saved image, or history.


# Preview
<img src="/preview1.png" alt="Alt text" title="Optional title"  height="200" width="400">
<img src="/preview2.png" alt="Alt text" title="Optional title"  height="200" width="400">
<br/>
<img src="/preview3.png" alt="Alt text" title="Optional title"  height="200" width="400">
<img src="/preview4.png" alt="Alt text" title="Optional title"  height="200" width="400">
<br/>
<img src="/preview5.png" alt="Alt text" title="Optional title"  height="200" width="400">

