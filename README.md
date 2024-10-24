## Menu App Tech Test

Hello, it was pleasant to develop this tech challenge and I feel grateful and happy with the opportunity. That being said, hope you appreciate the approach I took for this challenge.

### Getting Started

To get everything ready please run:

```
bundle
rails db:create db:migrate
rails s
```

### Versions

- Ruby: 3.2.3
- Rails: 7.0.8

### What was completed

1. Full CRUD for Restaurants
2. Full CRUD for Menus
3. Full CRUD for Menu Items
4. Import Endpoint and Service for Restaurant Data
5. Model and Controller Specs for Restaurants
6. Model and Controller Specs for Menus
7. Model and Controller Specs for Menu Items
8. Incomplete Specs for Restaurant Data Importer Service

### What was NOT completed

1. Import Restaurant Data Controller Endpoint Specs


### Decisions and notes

**On Pagination**

Pagination is essential for listing endpoints, since it was not required I decided to not spend time implementing it. Using kaminari, pagination implementation would be as simple as defining a page(params[:page]) on the scope of index retrieved collections, but it would consume time to write the specs considering pagination.

**On CORS**

In a real world application I would define the CORS for this application, rails gives us a CORS template that requires almost no changes in most cases. I decided to not spend time on that too, but Im aware on its importancy.

**On Filtering**

Another essential feature would be the ability to filter the listing endpoints. I have a large experience using Ransack and I believe would be a great addition in a real world project.

**On Serializers**

I'm not sure about the way you prefer to work when it comes to rendering json on rails. I have experience with jbuilder, but I'm more a serializer classes guy, so preference was the only key to decide on how to go here.

### Tests

To run the test specs all you need to do is to run:

```bash
bundle exec rspec
```

### Available Endpoints

On the root folder of this project there is a file called `MenusAPI.json` it is a postman collection. On the file there's an example body for each POST/PUT request and more details. How to import the Postman collection:

1. Open Postman
2. Press ⌘ + O (Mac) or Crtl + O (Windows/Linux)
3. Drag and Drop the json file on the modal that is displayed.

**Restaurants**

|Name |Path |Method |
|:----|:----|:------|
|List Restaurants |`/api/v1/restaurants` |GET |
|Show Restaurant |`/api/v1/restaurants/:restaurant_id` |GET |
|Create a Restaurant |`/api/v1/restaurants` |POST |
|Updates a Restaurant |`/api/v1/restaurants/:restaurant_id` |PUT/PATCH |
|Destroy a Restaurant |`/api/v1/restaurants/:restaurant_id` |DELETE |
|Import Restaurant Data |`/api/v1/restaurants/import` |POST |
|Show Info of Import Restaurant Data Endpoint |`/api/v1/restaurants/import` |OPTIONS |

**Menus**

|Name |Path |Method |
|:----|:----|:------|
|List Menus |`/api/v1/restaurants/:restaurant_id/menus` |GET |
|Show Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id` |GET |
|Create a Menu |`/api/v1/restaurants/:restaurant_id/menus` |POST |
|Updates a Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id` |PUT/PATCH |
|Destroy a Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id` |DELETE |

**Menu Items**

|Name |Path |Method |
|:----|:----|:------|
|List Menus |`/api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items` |GET |
|Show Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items/:menu_item_id` |GET |
|Create a Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items` |POST |
|Updates a Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items/:menu_item_id` |PUT/PATCH |
|Destroy a Menu |`/api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items/:menu_item_id` |DELETE |