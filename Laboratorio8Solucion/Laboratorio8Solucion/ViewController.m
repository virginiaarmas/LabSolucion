//
//  ViewController.m
//  Laboratorio8Solucion
//
//  Created by Virginia Armas on 7/8/13.
//  Copyright (c) 2013 Synergy-GB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize users = _users;
@synthesize currentElementValue = _currentElementValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _users = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)parseJSON:(id)sender {
   
    NSData* dataTemp = [self makeSynchronousRequest:@"http://synergy-gb.com/descargas/curso_iOS/LabJSONXML/DatosLabJSON.txt"];
    
    NSError *e = nil;
    id res = [NSJSONSerialization JSONObjectWithData:dataTemp
                                             options: NSJSONReadingMutableContainers
                                               error: &e];
    
    if ([res isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *phones = [res objectForKey:@"phones"];
        
        NSString *mobile = [phones objectForKey:@"mobile"];
        NSString *menssage = [[NSString alloc] initWithFormat:@"Nombre: %@ \n Apellido: %@ \n Celular: %@", [res objectForKey:@"name"], [res objectForKey:@"lastname"], mobile];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:menssage delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"Formato de JSON debe ser un dictionary");
    }


}
- (IBAction)parseXML:(id)sender {
    
    NSData* dataXML = [self makeSynchronousRequest:@"http://synergy-gb.com/descargas/curso_iOS/LabJSONXML/DatosLabXML.txt"];
    
    
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:dataXML];
    
    [nsXmlParser setDelegate:self];
    
    BOOL success = [nsXmlParser parse];
    
    if (success) {
        NSLog(@"No hubo errores");
    } else {
        NSLog(@"Error en el parseo de XML");
    }

    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"user"]) {
        NSLog(@"user element found ");
        _currentElementValue = nil;
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
 }

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_currentElementValue) {
        _currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        [_currentElementValue appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
 
    if ([elementName isEqualToString:@"users"]) {
        return;
    }
 
    if ([elementName isEqualToString:@"user"]) {
        [_users addObject:_currentElementValue];
    } else {
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
    }

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:[NSString stringWithFormat:@"Cantidad Usuarios = %d", [_users count]] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alert show];
    
    for (int i = 0; i < [_users count]; i++) {
        NSLog(@"%@", [_users objectAtIndex:i]);
    }
}

- (NSData*) makeSynchronousRequest:(NSString*) urlString {
    
    NSTimeInterval timeInterval = 10.0;
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeInterval];
    
    NSError        *error = nil;
    NSURLResponse  *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"result = %@", result);
    
    return data;
}

@end
