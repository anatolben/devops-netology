
# Решение домашнего задания к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

Ответ.  
Полная (аппаратная) виртуализация, когда гипервизор установлен непосредственно на хост. Называется полной потому, что для гостевой ОС полностью имитируется оборудование, как если бы гостевая ОС была установлена на физическом сервере.
Позволяет выполнять различные ОС на одном хосте.  
Паравиртуализация отличается от полной тем, что в гостевые ОС вносятся изменения для взаимодействия с гипервизором. Позволяет выполнять различные ОС на одном хосте.   
Виртуализация на основе ОС, это контейнерная виртуализация. Когда ядро ОС хоста выполняет независимо несколько изолированных пространств - контейнеров. Ограничивается эмуляцией только ОС поддерживающих ядро точно такое же как у хостовой ОС.  

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

Ответ.  
Высоконагруженная база данных, чувствительная к отказу - физические серверы.  
Современные базы данных "умеют" взаимодействовать с "железом" на аппаратном уровне, оптимизируя таким образом свою производительность.
Дополнительные слои абстракций, которыми является любая виртуализация будут препятствовать этим механизмам, и создавать дополнительные накладные расходы ресурсов хоста.

Различные Java-приложения.  
Java сама по себе является виртуализацией как концепт.  
Хотя существуют различные оптимизированные решения для исполнения Java в средах паравиртуализации.
В первую очередь рассмотрел бы для Java-приложений - виртуализацию уровня ОС.
Так как если бы она удовлетворила всем условиям эксплуатации, то была бы минимально необходимой и достаточной.
Если же по условиям эксплуатации есть специфика в обеспечении отказоустойчивости и безопасности, то тогда - паравиртуализация.

Windows системы для использования Бухгалтерским отделом - паравиртуализация.  
Возможность исполнения ОС Windows на хостах с различными ОС/гипервизорами.  

Системы, выполняющие высокопроизводительные расчеты на GPU.  
Физические серверы.  
В настоящее время решения для виртуализации GPU предлагают NVIDIA (аппаратно-программное) и Citrix Xen (программное), но они предназначены для пользовательских приложений использующих графику, а не для расчётов.

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

Ответ.  

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.  
Hyper-V. Выбор сделан исходя из описанных требований. Так как: "Windows based инфраструктура" к ней максимально адаптирован Hyper-V, Hyper-V включает решения по репликации данных и автоматизированному механизму создания резервных копий. Балансировка нагрузки программная - можно применить различные решения для этого.  

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.  
Citrix Xen. Наиболее производительное - "Xen". Open source - "Xen".  

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.  
Citrix Xen. Производительное - "Xen". Бесплатное - "Xen".  

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.  
KVM. Минимально достаточное, нормально отрабатывающее гостевые Linux машины.  

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

Ответ.  
1. Затраты ресурсов на поддержание двух сред виртуализаций, так как они требуют раздельного обновления и обслуживания.  
Периодическая установка обновлений систем виртуализации необходима в целях поддержания безопасности и исправления ошибок. Но для различных сред это абсолютно различные процессы.  
2. Усложнение автоматизации управления двумя средами.  
Например, различия в API двух сред, если мы используем автоматизацию управления.
3. Проблема несовместимости гостевых машин в разных средах.
Например, чтобы мигрировать гостевую машину с OS Windows из среды Hyper-V в VMware требуется обеспечить наличие в ней SCSI драйвера.  
Чтобы минимизировать риски и проблемы, требуется построение двух отдельных процессов поддержки и обслуживания. Поиск возможных кросс решений между этими средами.
А при возможности, не создавать гибридных сред, и стремиться к максимально возможной унификации решений на всех уровнях.  

---