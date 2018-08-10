# on-the-map

## Description

- The On The Map app allows users to share their location and a URL with their fellow students.
- The On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves “on the map”. 

## Setup
- In this application i used mapkit.
- For “On the Map”, the Udacity API will be used to authenticate users of the app and to retrieve basic user info before posting data to Parse.

## How to run it

- The login view accepts the email address and password that students use to login to the Udacity site. User credentials are not required to be saved upon successful login.
- Clicking on the Sign Up link will open Safari to the Udacity sign-up page. If the connection is made and the email and password are good, the app will segue to the Map and Table Tabbed View. If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.

- In the Map And Table Tabbed View, It has two tabs at the bottom: one specifying a map, and the other a table. When the map tab is selected, the view displays a map with pins specifying the last 100 locations posted by students.
- You will be able to zoom and scroll the map to any location using standard pinch and drag gestures.
- When you tap a pin, it displays the pin annotation popup, with the student’s name (pulled from their Udacity profile) and the link associated with the student’s pin. Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.Tapping outside of the annotation will dismiss/hide it.
- When the table tab is selected, the most recent 100 locations posted by students are displayed in a table. Each row displays the name from the student’s Udacity profile. Tapping on the row launches Safari and opens the link associated with the student.
- The rightmost bar button will be a refresh button. Clicking on the button will refresh the entire data set by downloading and displaying the most recent 100 posts made by students. The bar button directly to its left will be a pin button. Clicking on the pin button will modally present the Information Posting View.

- In the Information Posting View, It allows users to input their own data. When the Information Posting View is modally presented, you see two text fields: one asks for a location and the other asks for a link. When the user clicks on the “Find Location” button, the app will forward geocode the string. If the forward geocode fails, the app will display an alert view notifying the user. Likewise, an alert will be displayed if the link is empty.
- If the forward geocode succeeds then text fields will be hidden, and a map showing the entered location will be displayed. Tapping the “Finish” button will post the location and link to the server. If the submission fails to post the data to the server, then you will see an alert with an error message describing the failure. If at any point you click on the “Cancel” button, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View. Likewise, if the submission succeeds, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.

## Images for the App

![simulator screen shot - iphone 8 plus - 2018-08-10 at 16 53 54](https://user-images.githubusercontent.com/35192412/43965679-2f2f21fc-9cc0-11e8-9c6b-cb9e0b63c5c8.png)    ![simulator screen shot - iphone 8 plus - 2018-08-10 at 16 58 30](https://user-images.githubusercontent.com/35192412/43965683-317f69b2-9cc0-11e8-8a66-8ce1500f86a3.png)
![simulator screen shot - iphone 8 plus - 2018-08-10 at 16 58 12](https://user-images.githubusercontent.com/35192412/43965687-34711968-9cc0-11e8-983f-3cda3ccbc6f6.png)    ![simulator screen shot - iphone 8 plus - 2018-08-10 at 16 59 26](https://user-images.githubusercontent.com/35192412/43965689-35c22b36-9cc0-11e8-8392-7d2bfa4ed237.png)
