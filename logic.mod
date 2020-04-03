### INSIEMI 

#Insieme dei siti dove poter costruire un deposito
set SITI ; 
#Insieme degli enti
set ENTI ;

### PARAMETRI   

#Quantità massima di prodotto del deposito costruito nel sito i
param capacita{SITI} >=0;
#Costo di realizzazione e gestione del deposito costruito nel sito i
param f{SITI} >=0;
#Costo di stoccaggio per unità di prodotto in un deposito costruito nel sito i
param d{SITI} >=0;
#Scorta del deposito costruito nel sito i
param scorta{SITI} >=0;
#Quantità di prodotto richiesta dall’ente j
param richiesta{ENTI} >=0;
#Costo di trasporto per unità di prodotto dal sito i all’ente j
param c{SITI, ENTI} >=0;


#CONTROLLI

#Ogni deposito deve avere una quantità di prodotto vendibile oltre la scorta
check : sum{i in SITI} (capacita[i]-scorta[i])>0;
#La somma totale della quantità di prodotto vendibile dai depositi deve superare la richiesta
check : sum{i in SITI} (capacita[i]-scorta[i]) >= sum{j in ENTI} richiesta[j] ;

### VARIABILI

#Quantità di prodotto trasportata dal sito i all’ente j
var x{SITI, ENTI} >=0, integer;
#Variabile binaria che vale 1 se il deposito viene costruito nel sito i, altrimenti vale 0
var y{SITI} binary ;
#Quantità di prodotto rimanente nel deposito del sito i, se costruito; 
var z{SITI} >=0, integer;

### VINCOLI

#Per ogni deposito costruito nel sito, la quantità di prodotto inviata 
#deve essere <= della quantità massima di prodotto del deposito 
#salvaguardando una parte di scorta
subject to depositi_siti {i in SITI} : 
sum{j in ENTI} x[i,j] <= (capacita[i]-scorta[i])*y[i];

#I prodotti trasportati da ciascun deposito in un sito devono essere uguali alla richiesta di ciascun ente
subject to richiesta_enti {j in ENTI}: sum{i in SITI}
x[i,j] = richiesta[j] ;

#Se y[i]=1, z[i] contiene il prodotto rimanente del deposito i altrimenti contiene 0
subject to stoccaggio_deposito {i in SITI}: 
z[i]  >=  capacita[i] * y[i] - sum{j in ENTI} x[i,j]; # 0<=z[i]<=capacita[i]

#Eventuale vincolo per definire un numero massimo di depositi da costruire (non richiesto dalle specifiche)
#subject to massimo_depositi: sum{i in SITI} y[i] <= 2; 


### OBIETTIVO   

#Minimizzare il costo totale
minimize costo_totale : sum{i in SITI, j in ENTI} c[i,j]*x[i,j] + sum{i in SITI} f[i]*y[i] + sum{i in SITI} d[i]*z[i];
