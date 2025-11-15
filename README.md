CSVServer Assignment
Part I – Run CSVServer with inputFile

Steps performed:

Pull and run CSVServer container:

docker run -d --name csvserver-test infracloudio/csvserver:latest
docker ps
docker logs csvserver-test


Observed failure due to missing input file.

Created script gencsv.sh to generate inputFile:

chmod +x gencsv.sh
./gencsv.sh 2 8


inputFile content:

2, 249
3, 270
4, 266
5, 52
6, 139
7, 49
8, 120


Run CSVServer with inputFile and Orange border:

docker run -d --name csvserver \
  -p 9393:9300 \
  -v $(pwd)/inputFile:/csvserver/inputdata \
  -e CSVSERVER_BORDER=Orange \
  infracloudio/csvserver:latest


Tested application:

curl http://localhost:9393/raw


Saved commands, output, and logs:

echo 'docker run -d --name csvserver -p 9393:9300 -v $(pwd)/inputFile:/csvserver/inputdata -e CSVSERVER_BORDER=Orange infracloudio/csvserver:latest' > part-1-cmd
curl -o ./part-1-output http://localhost:9393/raw
docker logs csvserver >& part-1-logs


Files generated:

gencsv.sh

inputFile

part-1-cmd

part-1-output

part-1-logs

Part II – Docker Compose Setup

Steps performed:

Deleted any running containers from Part I:

docker compose down


Created docker-compose.yaml to run CSVServer:

Included environment variables in csvserver.env.

Exposed application on host at http://localhost:9393.

Run via Docker Compose:

docker compose up -d
docker ps
curl http://localhost:9393/raw


Pushed changes to GitHub including:

docker-compose.yaml

csvserver.env

Part III – Prometheus Integration

Steps performed:

Created prometheus.yml to monitor CSVServer metrics:

scrape_configs:
  - job_name: 'csvserver'
    static_configs:
      - targets: ['csvserver:9300']


Updated docker-compose.yaml to include Prometheus container:

Image: prom/prometheus:v2.45.2

Exposed Prometheus at http://localhost:9090

Configured to scrape CSVServer /metrics.

Run Docker Compose:

docker compose up -d
docker ps


Tested metrics:

Open http://localhost:9090

Query: csvserver_records → Graph shows straight line at value 7.
