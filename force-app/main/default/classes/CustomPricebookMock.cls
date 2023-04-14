@isTest
global class CustomPricebookMock implements HttpCalloutMock {

    // This method is required by the HttpCalloutMock interface
    global HttpResponse respond(HttpRequest Request) {
        // Create a new HTTP response object
        HttpResponse response = new HttpResponse();

        // Set the response header to indicate that the response will be in JSON format
        response.setHeader('Content-Type', 'application/json,charset-UTF-8');

        // Set the body of the response to a sample JSON payload
        response.setBody('[{"id":1,"title":"Fjallraven -Foldsack No. 1 Backpack, Fits 15 Laptops","price":109.95,"description":"Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday","rating":{"rate":3.9,"count":120}},{"id":2,"title":"Mens Casual Premium Slim Fit T-Shirts ","price":22.3,"description":"Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.","rating":{"rate":4.1,"count":259}}]');

        // Set the status code of the response to 200 (OK)
        response.setStatusCode(200);

        // Return the response
        return response;
    }
}