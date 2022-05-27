#!/bin/bash

# Установка утилит мониторинга
yum install -y {jnet,h,io,if,a}top iptraf nmon

# Скачиваем, можно через wget
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.34.0/prometheus-2.34.0.linux-amd64.tar.gz
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

# Распаковка архивов 
tar xzvf node_exporter-*.t*gz
tar xzvf prometheus-*.t*gz

# Добавляем пользователей
useradd --no-create-home --shell /usr/sbin/nologin prometheus
useradd --no-create-home --shell /bin/false node_exporter

# Установка node_exporter

# Копируем файлы в /usr/local
cp node_exporter-*.linux-amd64/node_exporter /usr/local/bin
chown node_exporter: /usr/local/bin/node_exporter

# Создаём службу node exporter

cd /home/

git clone git@github.com:AleksandrMalinovskiy/monitoring.git

mv /home/monitoring/node_exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl start node_exporter
systemctl status node_exporter
systemctl enable node_exporter

echo "node_exporter установлен" 


read -p "Установливаем prometheus?(yes/no)" r

if
	[ "$r" = yes ];
then

# Установка prometheus

# Создаём папки и копируем файлы
mkdir {/etc/,/var/lib/}prometheus
cp -vi prometheus-*.linux-amd64/prom{etheus,tool} /usr/local/bin
cp -rvi prometheus-*.linux-amd64/{console{_libraries,s},prometheus.yml} /etc/prometheus/
chown -Rv prometheus: /usr/local/bin/prom{etheus,tool} /etc/prometheus/ /var/lib/prometheus/

# Настраиваем сервис

cd /home/

mv /home/monitoring/prometheus.service /etc/systemd/system/

# Конфиг prometheus

mv /home/monitoring/prometheus.yml /etc/prometheus/

# Запускаем сервис Prometheus
systemctl daemon-reload
systemctl start prometheus
systemctl status prometheus
systemctl enable prometheus

elif
	[ "$r" = no ];
then
	echo "ERROR"
	exit
fi

echo "Node_exporter установлен" 
echo "Prometheus установлен"


read -p "Установливаем grafana?(yes/no)" r

if
	[ "$r" = yes ];
then


# Установка Grafana

mv /home/monitoring/grafana.repo /etc/yum.repos.d/

# Установка
yum install grafana

# Запуск
systemctl daemon-reload
systemctl start grafana-server
systemctl status grafana-server

elif
	[ "$r" = no ];
then
	echo "ERROR"
	exit
fi
