public with sharing class CustomPricebook {
    
    // Method to get the products from a remote API and insert them into the database as PricebookEntries
    public static List<PricebookEntry> priceBookGetCallout() {
        // Create a new HTTP object
        Http http = new Http();
        // Create a new HTTP request with the endpoint and method specified
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://fakestoreapi.com/products');
        request.setMethod('GET');
        // Send the request and get the response
        HttpResponse response = http.send(request);
        
        // Initialize lists for holding products and PricebookEntries
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> pribookEntry = new List<PricebookEntry>();
        List<PricebookEntry> standardPribookEntries = new List<PricebookEntry>();
        
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            
            // Create a new Pricebook2 object to hold the new pricebook
            Pricebook2 priceBook = new Pricebook2(
                Name = 'Jay Price Book',
                Description = 'This is the Jay Book description.',
                IsActive = true
            );
            
            // Insert the new pricebook into the database
            insert priceBook;
            
            // Get the Id of the standard pricebook, which is used later
            Id standardPribookId;
            if(Test.isRunningTest()){
                standardPribookId = Test.getStandardPricebookId();
            } else {
                Pricebook2 standardPribook = [Select id,name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
                standardPribookId = standardPribook.Id;
            }
            
            // Loop through each product in the JSON response
            for(Object product: results) {
                // Convert the product to a Map
                Map<String,Object> productMap = (Map<String,Object>) product;

                // Create a new Product2 object to hold the product
                Product2 prod = new Product2();
                prod.ProductCode = String.valueOf(productMap.get('id'));
                prod.Name = String.valueOf(productMap.get('title'));
                prod.Description = String.valueOf(productMap.get('description'));
                products.add(prod);
                
                // Create a new PricebookEntry for the standard pricebook
                PricebookEntry standardPriceEntry = new PricebookEntry();
                standardPriceEntry.UnitPrice = (decimal) productMap.get('price');
                standardPriceEntry.Pricebook2Id = standardPribookId;
                standardPriceEntry.IsActive = true;
                standardPribookEntries.add(standardPriceEntry);
                
                // Create a new PricebookEntry for the new pricebook
                PricebookEntry priceEntry = new PricebookEntry();
                priceEntry.UnitPrice = (decimal) productMap.get('price');
                priceEntry.Pricebook2Id = priceBook.id;
                priceEntry.IsActive = true;
                pribookEntry.add(priceEntry);
            }
            
            // Insert the new products into the database
            insert products;
            
            // Assign each PricebookEntry to a Product2 object and insert them into the database
            Integer count = 0;
            for(Product2 product:products){
                standardPribookEntries[count].Product2Id = product.id;
                pribookEntry[count].Product2Id = product.id;
                count++;
            }
            insert standardPribookEntries;
            insert pribookEntry;
        }
        
        // Return the pribookEntry
        return pribookEntry;
    }
}