from flask import Flask, render_template, request, g
import mysql.connector

app = Flask(__name__)

@app.before_request
def before_request_func():
    #                          !!!!!!!!!!!!!!!!!!!!!!!!!!!  
    #                          !!! CHANGE THESE VALUES !!!
    #                          !!!!!!!!!!!!!!!!!!!!!!!!!!!
    g.db = mysql.connector.connect(host='localhost',
                                   user='root',
                                   password='',
                                   database='')
    g.cursor = g.db.cursor(dictionary=True)

@app.teardown_request
def teardown_request_func(response):
    if hasattr(g, 'cursor'):
        g.cursor.close()
    if hasattr(g, 'db'):
        g.db.close()
    return response


@app.route('/')
def start():
    g.cursor.execute("SELECT * FROM Item")
    Item = g.cursor.fetchall()
    return render_template("Start.html", Item=Item)

@app.route('/Traveling_Merchant/Traveler', methods=['POST'])
def Traveling_Between_Cities():
    Amount = request.form['Quantity']
    ItemID = int(request.form['Item'])

    g.cursor.execute("SELECT * FROM Item")
    Item_List = g.cursor.fetchall()
    g.cursor.execute("""(SELECT City.City_Name as City, Market.Price as 'Price' 
                     FROM Market 
                     JOIN City ON Market.CityID = City.CityID 
                     WHERE Market.Price = (
	                 SELECT min(Market.Price) 
                     FROM Market 
                     WHERE Market.ItemID LIKE %s
                     )) 
                     UNION ALL 
                     (SELECT City.City_Name as City, Market.Price as 'Price' 
                     FROM Market 
                     JOIN City ON Market.CityID = City.CityID
                     WHERE Market.Price = ( 
	                 SELECT max(Market.Price) 
                     FROM Market  
                     WHERE Market.ItemID LIKE %s  
                     ))""",(f'%{ItemID}%',f'%{ItemID}%'))
    Price_Diffs = g.cursor.fetchall()
    print(Price_Diffs)
    Profit = int(Amount) * ((Price_Diffs[1]['Price']) - (Price_Diffs[0]['Price']))

    

    return render_template("Traveling.html", Items=Item_List, Prices=Price_Diffs, Profit=Profit)

@app.route('/Item_Price', methods=['POST'])
def Show_Item_Prices():
    ItemID = int(request.form['Item'])

    g.cursor.execute(
     """SELECT City.City_Name AS City, Item.Item_Name AS Item, Market.Price 
        FROM Market 
        JOIN Item ON Market.ItemID = Item.ItemID 
        JOIN City ON Market.CityID = City.CityID 
        WHERE Market.ItemID LIKE %s 
        ORDER BY Price DESC;""", (f"%{ItemID}%",))
    Item_List = g.cursor.fetchall()

    g.cursor.execute("SELECT * FROM Item")
    Item = g.cursor.fetchall()

    g.cursor.execute(
        """SELECT ROUND(AVG(Price), 2) AS "Average", round(STD(Price), 2) as "Standard_Deviation"
           FROM Market
           WHERE ItemID LIKE %s;
        """, (f"%{ItemID}%",))
    Stats = g.cursor.fetchall()

    return render_template("Item_Price.html", Item_List=Item_List, Item=Item, Stats=Stats)

@app.route('/Update')
def Update_Database():
    g.cursor.execute("SELECT * FROM Item")
    Items = g.cursor.fetchall()
    g.cursor.execute("SELECT * FROM City")
    Cities = g.cursor.fetchall()
    g.cursor.execute("SELECT * FROM Market_Log order by Change_Date desc")
    Logs = g.cursor.fetchall()

    return render_template("Update.html", Items=Items, Cities=Cities, Logs=Logs)

@app.route('/Update/Done', methods=['POST'])
def Updated_Database():
    ItemID = int(request.form['ItemID'])
    CityID = int(request.form['CityID'])
    New_Price = int(request.form['New_Price'])

    g.cursor.callproc('Update_Price', (CityID,ItemID,New_Price))
    g.db.commit()

    g.cursor.execute("SELECT * FROM Item")
    Items = g.cursor.fetchall()
    g.cursor.execute("SELECT * FROM City")
    Cities = g.cursor.fetchall()
    g.cursor.execute("SELECT * FROM Market_Log order by Change_Date desc")
    Logs = g.cursor.fetchall()

    return render_template("Update_Done.html", Items=Items, Cities=Cities, Logs=Logs)

@app.route('/Traveling_Merchant')
def Traveling_Start():

    g.cursor.execute("SELECT * FROM Item")
    Items = g.cursor.fetchall()
    return render_template("Travel.html", Items=Items)

@app.route('/Recipe')
def Recipe():

    g.cursor.execute("""SELECT Item.Item_Name AS "Name", Recipe.Result_ItemID as "ID"
                        FROM Recipe 
                        JOIN Item ON Recipe.Result_ItemID = Item.ItemID
                        GROUP BY Recipe.Result_ItemID;""")
    Craftable = g.cursor.fetchall()

    return render_template("Recipe.html", Craftable=Craftable)

@app.route('/Recipe/Show', methods=['POST'])
def Show_Recipe():
    ItemID = int(request.form['Craft'])

    g.cursor.execute("""SELECT Item.Item_Name AS "Name", Recipe.Result_ItemID as "ID"
                        FROM Recipe 
                        JOIN Item ON Recipe.Result_ItemID = Item.ItemID
                        GROUP BY Recipe.Result_ItemID;""")
    Craftable = g.cursor.fetchall()

    g.cursor.execute("""SELECT Item.Item_Name as Item, Recipe.Amount
                        FROM Recipe 
                        JOIN Item ON Recipe.IngredientID = Item.ItemID
                        WHERE Recipe.Result_ItemID LIKE %s;""",(f'%{ItemID}%',))
    Recipe = g.cursor.fetchall()
    return render_template("Recipe_Show.html", Craftable=Craftable, Recipe=Recipe)

@app.route("/Analytics")
def Markets():

    g.cursor.execute("""SELECT * FROM City;""")
    Cities = g.cursor.fetchall()

    return render_template("Markets.html", Cities=Cities)

@app.route("/Analytics/Show", methods=['POST'])
def Markets_Show():
    CityID = int(request.form['Cities'])

    g.cursor.execute("""SELECT * FROM City;""")
    Cities = g.cursor.fetchall()

    g.cursor.execute("""SELECT SUM(Price) as Sum, round(AVG(Price),1) as Average, Count(ItemID) as Count, Max(Price) as Max, Min(Price) as Min, round(STD(Price),1) as SD
                        From Market
                        WHERE CityID LIKE %s;""",(f'%{CityID}%',))
    Stats = g.cursor.fetchall()

    g.cursor.execute("""SELECT City_Name as Name FROM City
                        WHERE CityID Like %s;""",(f'%{CityID}%',))
    City_Name = g.cursor.fetchall()
    print(City_Name)
    return render_template("Markets_Show.html", Cities=Cities, Current_City = City_Name, Stats = Stats)

if __name__ == "__main__":
    app.run()
