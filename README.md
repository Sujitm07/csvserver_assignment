Part I – Run CSVServer with inputFile
1. Clone Repository

git clone https://github.com/infracloudio/csvserver
cd csvserver/solution

2. Pull and Run CSVServer

Initial run failed due to missing input file:


docker run -d --name csvserver infracloudio/csvserver:latest
docker logs csvserver

3. Create gencsv.sh to generate inputFile


vi gencsv.sh
chmod +x gencsv.sh
./gencsv.sh 2 8

4. Generated inputFile
2, 249
3, 270
4, 266
5, 52
6, 139
7, 49
8, 120

5. Run CSVServer with inputFile + Orange Border




docker run -d --name csvserver \
  -v /root/csvserver/solution/inputFile:/csvserver/inputdata \
  -p 9393:9300 \
  -e CSVSERVER_BORDER=Orange \
  infracloudio/csvserver:latest

6. Test Application
curl http://localhost:9393/raw

7. Save Outputs
echo 'docker run -d --name csvserver -p 9393:9300 -v /root/csvserver/solution/inputFile:/csvserver/inputdata -e CSVSERVER_BORDER=Orange infracloudio/csvserver:latest' > part-1-cmd

curl -o ./part-1-output http://localhost:9393/raw

docker logs csvserver >& part-1-logs



Part II – Docker Compose Setup
1. Created docker-compose.yaml and csvserver.env

docker compose down
vim docker-compose.yaml
vim csvserver.env



2. Run with Docker Compose

   
docker compose up -d
docker ps
curl http://localhost:9393/raw
docker compose logs csvserver



Part III – Prometheus Integration
1. Created prometheus.yml
scrape_configs:
  - job_name: 'csvserver'
    static_configs:
      - targets: ['csvserver:9300']


docker compose down
vim prometheus.yml
vim docker-compose.yaml
docker compose up -d
docker ps
docker compose logs prometheus

2. Updated docker-compose.yaml

Added:

prom/prometheus:v2.45.2

Port mapping for Prometheus: 9090:9090

Volume mount for prometheus.yml

3. Start Services
docker compose up -d
docker ps

4. Verify Metrics

Open Prometheus UI:

http://localhost:9090


Run query:

csvserver_records


Observation: Graph displays a straight line at value 7, matching the number of records in inputFile.
