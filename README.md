***_SALES FORECASTING ECOMMERCE_***

El comercio electrónico se mueve por unos parámetros distintos a los de la distribución
minorista tradicional en tiendas de “ladrillo”. Si bien presenta ventajas evidentes, como 
son la eliminación de los costes de creación y mantenimiento del establecimiento de 
venta físico, así como de los costes del personal que lo atiende, y una clientela 
potencial global, también presenta inconvenientes, como son la volatilidad de la 
clientela, el mantenimiento de stocks horizontal y verticalmente enormes y los 
problemas logísticos, tanto de abastecimiento como de entrega del producto al cliente 
final.
Los sistemas de predicción de ventas (*sale forecasting*) resultan aquí muy útiles, 
porque permiten planificar el abastecimiento y la creación de stocks y prevenir cuellos 
de botella por picos de demanda estacionales o relacionados con lanzamientos de 
nuevos productos.

## CASO DE USO

Una empresa de *e-commerce* B2C generalista nos plantea cómo mejorar su estrategia de marketing digital para que mejoren sus ventas futuras.

**Preguntas a las que quieren que encontremos respuesta:**

* ¿Cómo son nuestros clientes actuales (Cuál es su comportamiento de compra) y el mercado?

* KPIs de nuestra web (ratio de abandonos durante el proceso de compra, porcentaje de compra sobre visitas, cuantos clientes repiten, etc)

* *User journeys* de varios clientes representativos

* Estadísticas de venta de productos y marcas y si existe venta cruzada en la web

* Segmentación de clientes por producto/mercado

* ¿Podemos obtener un modelo que pueda predecir las ventas, tanto actuales como a futuro (p. ej. 1 mes o, incluso, 6 meses)?

* ¿Nos podrían recomendar, en combinación con otras fuentes de datos aparte de uniendo otros datos cual debería ser el efecto del enriquecimiento sobre nuestro ecommerce?

**Dataset**

Para nuestro estudio y nuestras proyecciones el cliente nos ha proporcionado el dataset siguiente:

[Dataset original](https://drive.google.com/drive/folders/1n78LbqzTnfvkQ8yWCbjJdqaEkHJAIJ3-?usp=sharing)

Consta de siete archivos en formato **csv**, uno por mes dentro del periodo **Octubre 2019 - Abril 2020**, con un tamaño medio de 7GB por archivo. Cada fila de los archivos representa un evento provocado por un usuario del sitio de comercio electrónico. Todos los eventos están relacionados con productos y usuarios. Cada evento es como una relación de muchos a muchos entre productos y usuarios.


## PROPUESTA DE SOLUCIÓN AL CASO

### Ciclo de vida del proyecto

![](https://media.geeksforgeeks.org/wp-content/uploads/20200805200955/datasc.png)

### Entendimiento del negocio

Herramientas utilizadas:

	* Internet
	* Entrevista a personas del sector

Conclusión:

Se ha realizado una investigación por internet para saber cuales son los KPI esenciales del negocio del e-commerce y cuales son la información que podría necesitar. De este examen hemos visto que la informaciónn relevante para un e-commerce es:

	* Conocer la *churn rate* (tasa de abandono por parte de clientes) y ratios de conversión (en contrato a ventas)
	* Análisis RFM [Análisis RFM](https://www.ibm.com/docs/es/spss-statistics/saas?topic=marketing-rfm-analysis)
	* Predicción de ventas futuras
	* Datos externos sobre (p. ej. de *Google Trends*), para cruzarlos con el dataset proporcionados

Para dar respuesta a estas necesidades utilizaremos Big Data con distintas herramientas, que explicaremos a continuación.
	
### Preparación de los datos (carpeta **preparacion**

**Herramientas utilizadas:**

	* PostgreSQL
	* PySpark
	* Google Colab Pro con GPU
	* Pandas en local
	* PyTrends

**Justificación de su utilización:**

Se ha utilizado estas dos herramientas debido al tamaño de la base de datos. En relación a PySpark se ha utilizado las funciones de SQL en un Standalone de Google Colab Pro con GPU para permitir un procesamiento más rápido de los datos. Respecto a PostgreSQL se ha utilizado SQL para unir los ficheros en una sola base de datos y después exportar la base completa a a CSV.

**Trabajo realizado:**

Existen tres ficheros donde se detalla el código utilizado en el trabajo:

			1. Postgresql_script.sql ()[preparacion/Postgresql_script.sql)
			Script de Base de Datos PostgreSQL en equipo local más DBeaver como interface gráfica para realizar las consultas. Se realizan diferentes selects para agregar los datos de los *csv* de los eventos del ecommerce en una única base de datos y al final cuando se tienen todos unidos se realiza una exportación a un CSV único.
			2. PySpark_EDA.ipnyb () [PySpark_EDA.ipnyb]
			Se define una variable por cada uno de los ficheros csv de los eventos del e-commerce mensuales y después se unen los valores de todas las variables en una única. Por último se exportan los datos a un fichero csv. Este proceso se realiza con un proceso de copia temporal hasta que termina de copiar todos los datos en dicho fichero *csv*. Este proceso es bastante intensivo en memoria y puede hacer que la maquina de google colab se quede sin capacidad necesaria para realizarlo y haya que lanzarlo más de una vez para obtener el resulado deseado.
			3. Pandas en local
			Finalmente hemos optado por continuar el procesamiento del fichero *csv* con Pandas en una máquina local provista de 32GB de RAM. El procesamiento ha consistido en filtrar los eventos que contenían el valor 'sale' en la columna 'event_type'. Estos eventos son los que realmente nos interesan para realizar el *sale forecasting*. En el EDA (ver la sección [EDA](#eda) se ha extraido un subset de este set que contiene únicamente los eventos de venta relativos a smartphones. Asimismo se han extraído todas las marcas vendidas.
			4. GoogleTrends.ipnyb () [GoogleTrends.ipnyb]
			Se ha utilizado GoogleTrends para obtener series históricas de popularidad en cuanto a búsquedas en Google a lo largo del periodo de referencia (octubre 2019 - abril 2020) para las marcas del subset *Smartphones* (ver punto anterior). Estas búsquedas no estás restringidas a una localización geográfica determinada.

**Conclusiones:**

De las dos herramientas se ha visto que es más eficiente y rápida realizar la consulta con PySpark, aparte de darte la versatilidad de poder realizar consultas SQL y procesamiento con pandas. Sí se han apreciado limitaciones al realizar el trabajo sobre la memoria ofrecida por Google Colab en su versión gratuita. Se propone que la solución en producción se planifique sobre un entorno con Dockers+Kubernetes en el que se ejecute PySpark o en un entorno cloud, que puede ser GCP.


### <a name="eda"></a>EDA

**Herramientas utilizadas:**

	* Numpy
	* Pandas
	* Maplotlib
	

**Justificación de su utilización:**

Se utiliza numpy y pandas por su facilidad para el tratamiento de los datos y la manipulación de los mismos. No se utiliza pySpark porque aquí el tamaño de los datos no es crítico ya que se ha reducido considerablemente al estar trabajando con un fichero de un tamaño menor a un 1 GB.

Trabajo realizado:

Los ficheros con código son:

	4. EDA.ipnyb
	5. Maplotlib.ipnyb
	6. Preprocesamiento_multistore.ipnynb
	7. KPI.ipnyb
	Se utilizan los datos solo del mes de diciembre para realizar y ver los datos claves a controlas del ecommerce coomo pueden ser cuales son las marcas que más venden, cual es la cifra de negocios para este mes, cuales son los ratios de conversión, cual es la categoría de producto más vista. Después se hace un análisis sobre la categoría de smartphone, ya que es el producto estrella de este ecommerce. Se realiza un análisis RFM que permite segmentar a los clientes en base a parámetros como el tiempo que ha pasado desde la última compra (R - Recency o Reciente), la frecuencia con la que realizan compras (F - Frequency o Frecuencia) y la suma total de todas las compras (M - Monetary Value o Valor Monetario).
	8. Customer journey
	Se ha utilizado las librerias de panda y numpy para poder realizar un customer journey del proceso de compra de un cliente en el ecommerce. Así se podría ir analizando donde estan los cuellos de botella en uníon con los datos de Google Analytics y los Heatmaps de la usabilidad del ecommerce.
	
	
**Conclusiones:**

Con el anális de los KPI del ecommerce podemos dar una visión sobre cuáles son las marcas más representativas y su contribución a la cifra de negocios, así como los ratios de conversión que permitan el realizar campañas de marketing digital para mejorarlo. Asimismo, el análisis RFM permite el establecer diferentes estrategias de marketing en función del cluster en el que este encuadrado nuestro cliente. Todas estas herramientas e información que le podemos dar rebundará en una mejor estrategia de marketing digital y por tanto en una posible mejora de la cifra de negocios en meses o años sucesivos, así como conocer mejor a nuestro cliente en función de sus hábitos de compra.


### Modelado de datos/Evaluación del modelo

**Herramientas utilizadas:**

	* Numpy
	* Pandas
	* Maplotlib
	* Scikit-Learn
	* Prophet
	* Neuralprophet

Justificación de su utilización:

Se utiliza Sklearn Learning para realizar cluster, no utilizamos Deep Learning por el tamaño reducido de los datos en este caso y prophet/neuralprophet para series temporales ya que es una herramienta con un alto componente visual y una alta potencia de cálculo. Neuralprophet se ha hecho uso de esta libreria por el poder utilizar deep learning con series temporales.

Los ficheros con código son:

	9. Market basket analisis.ipnyb
	En este notebook se realiza una técnica de cluster para establecer si existe venta cruzada entre los productos que se vende y así poder realizar campañas con los productos que se suelen comprar a la vez. Se utiliza Scikit-learn porque el tamaño del fichero no es muy grande y porque su interpretación es más facil que con deep learning. Se establece una tabla con los productos que se compran a la vez en relación a su grado de correlación en la compra
	
	10. Prediccion.ipnyb

	Se utiliza la API de Prophet para Python, ya que estamos con una serie temporal del importe de las ventas en cada día para ver si existe una temporalidad y se obtiene que hay una fuerte temporaralidad que lleva a una gráfica de dienntes de sierra que comienza con ventas a finales de la semana con caidas al inicio de la semana. Se observa también que los datos más altos de la serie estan en el mes de febrero. Todo esto lleva a indicar que este dataset es de un país asiático ya que las fiestas de año nuevo se celebran sobre esa época y que sea musulman pricipalmente ya que el viernes y sábaod es fiesta mientras que el domingo no. Esta estacionalidad se intennta solventas con diferentes técnica, pero a pesar de ello en la valoración del modelo no es muy aceptable. Uttilizamos la versión de deep learning del modelo que es Neuraprophet y se ve que aproxima más el modelo a los datos reales. Con lo cual con esta última herramienta, neuralprophet, es con la que se predice las ventas del mes de mayo que no se tiene datos en el data set. También se aprecia que cuanto más alejada es la predicción de los datos reales existe una mayor variabilidad en la proyección. También se ha utilizado un analisis añadiendo como regresor los datos de Google Trends para la marca Apple y se ve que su proyección es que su índice se vea mejorado en un futuro
	
	
A nivel de visualización de los resultados hemos utilizado D3 y Power BI para poder ver la diferencia en la capacidad de visualización y de análisis visual de estas dos herramientas. Ademas se ha realizado con Flask una aplicación en local para poder ver el análisis EDA del ecommerce.


 ### Desarrollo del modelo/Modelo en producción

**Herramientas utilizadas:**

	* Gitlab
	* Google Colab Pro
	* Google Cloud Platform, siendo el pipeline el siguiente:


![](https://miro.medium.com/max/1400/1*5GO-VhXyPCo_NL5SwYaWkQ.png)


**Justificación de su utilización:**

Para poderlo llevar a producción se realizaría en GCP para poder automatizar todo el proceso que se ha realizado en local en esta versión preproducción, debido a la agilidad  de haberlo realizado en local en un repositorio en Gitlab pero nos hemos visto limitados a la hora del procesamiento debido al gran volumen de datos generados.

La arquitectura de datos propuesta se compone de un pipeline que comienza con una ingesta de datos en streaming proveniente de los eventos del ecommerce diarios y por otra parte los datos de Google Trends en relación a los indices de busquedas por pais y marca. Se realizaría con **Cloud Pub/Sub** con la API de PyTrends y con un código en Google Colab que permita automatizar Google DataFlow y Apache Beam para la toma de los datos en streaming.

Una vez que se tiene los datos, el siguiente paso es el preprocesamiento de los mismos para ello utilizamos como ETL **Databricks** ya que tiene embebido la arquitectura Spark permmitiendo el tratamiento de grandes volumenes de datos. Con ello realizaríamos un tratamiento y limpieza de los datos para obtener nuestro Data Lake que lo gestionaremos con **Delta Lake** debido a su integración con Databricks. Todo ellos con el archivo de los datos en Cloud Storage, porque es más eficiente en utilizar menos espacio para una gran cantidad de datos.

Para el EDA y procesamiento de los datos, volveremos a utilizar el Spark de Databricks pero dado que iremos utilizando diferentes consultas el repositorio de la base de datos será BigQuery, por su facilidad en el procesamiento de grandes cantidades de datos ya que Cloud Storage es más lenta a la hora de procesar.

A la hora de realizar el modelado de los datos se realizará con Databricks para el filtrado de los datos pero el procesamiento de los modelos se va a programar en **Vertex AI**, por la facilidad del montaje de la infraestructura de Kubernetes y Docker para realizar el procesamiento en diferentes maquinas virtuales en paralelo y el aprovechamiento de la GPU. Todos los datos obtenidos se archivarán en BigQuery de nuevo como repositorio.

Para la visualización del trabajo se va a realizar con Looker ya que esta embebida en GCP y perfectamente conectada con BigQuery. Permitiendo ver los dashboards de los análisis del trabajo mediante una conexión web.

### Presentación

**Herramientas utilizadas:**
	* Powerpoint
	* PowerBI
	* Aplicación web realizada con la librería Flask de Python, servida por Nginx

**Justificación de su utilización:**

Los factores principales del éxito de la presentación de resultados al cliente son la claridad, la expresividad y la concisión. El cliente no quiere saber qué herramientas hemos utilizado, ni qué pipeline hemos aplicado. Quiere obtener respuestas concluyentes y claramente expresadas a las preguntas de su encargo. Para ello nos hemos apoyado en una herramienta estática (Powerpoint) y dos herramientas dinámicas. La presentación Powerpoint está pensada para su uso en la presentación presencial de resultados y como documento fácilmente distribuible dentro de la empresa cliente, tanto en formato físico como electrónico. La presentación PowerBI, al añadir características interactivas, está pensada para uso directo por parte de los analistas de datos y responsables de toma de decisiones dentro de la empresa. Finalmente la aplicación web, está pensada como herramienta de trabajo, que permite realizar consultas de KPIs y forecastings. Es la interfaz gráfica de la arquitectura de ingesta, procesamiento, análisis y predicción que hemos creado. Su ubicación natural es un servidor de la Intranet de la empresa.



## CONCLUSIÓN FINAL DEL TRABAJO

La conclusión final es que nos hemos dado cuenta de la dificultad del trabajo a la hora de tratar y modelar data set de un tamaño considerable, en nuestro caso de 50GB. Pero este tamaño es pequeño con la inmensa generación de datos en la vida real de una empresa. Además este dataset esta bastante virgen, en el sentido que no es un dataset académico sino que son datos reales con sus ineficacias y sus problemas (datos duplicados, outliers por errores de procesamiento, circunstancias temporales no previstas, etc).

Hemos visto que se necesita un entorno de desarrollo cloud para poder configurar la aplicación en producción debido a que sino no se podría automatizar y el elevado coste de ternerlo on premise.

Nos ha gustado mucho el poder utilizar herramientas que hemos visto en el bootcamp y otras que gracias a lo aprendido aunque no las hemos dado no ha sido dificil su aplicación.

Creemos que el trabajo realizado se puede llevar a producción y que muchas PYMES o empresas que no tengan departamentos de Data Sciences podrían pagar por tener esta información ya que les va a permitir el aumentar su ventas con un enfoque Data Driven.

