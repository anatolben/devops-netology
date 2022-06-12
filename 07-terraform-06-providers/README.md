# Решение домашнего задания к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   

**Ответ:**  
[`resource`](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L902-L2056)  
[`data_source`](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L423-L898)  

2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 

**Ответ:**  
[конфликтует с `name_prefix`](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L87)  

[максимальное количество символов `name` = 80](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427)  

[регулярное выражение 1](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427)  
или  
[регулярное выражение 2](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L425)  


---
