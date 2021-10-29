# devops-netology
for DEVSYS-PDC-2  
  
added this line  
  
added line for '#3 branchs'  
  
## Правила файла [.gitignore](https://github.com/anatolben/devops-netology/blob/main/terraform/.gitignore) каталога terraform
  
<pre><code>**/.terraform/*</code></pre>  
исключаем содержимое каталогов '.terraform', которые расположены на любом уровне вложенности  
  
<pre><code>*.tfstate</code></pre>  
<pre><code>*.tfstate.*</code></pre>  
исключаем файлы с расширением 'tfstate' и с расширением начинающимся с 'tfstate.' 
  
<pre><code>crash.log</code></pre>  
исключаем файлы 'crash.log'  
  
<pre><code>*.tfvars</code></pre>  
исключаем файлы с расширением 'tfvars'  
  
<pre><code>override.tf</code></pre>  
<pre><code>override.tf.json</code></pre>  
исключаем файлы 'override.tf' и 'override.tf.json'  
  
<pre><code>*_override.tf</code></pre>  
<pre><code>*_override.tf.json</code></pre>  
исключаем файлы оканчивающиеся на '_override.tf' и '_override.tf.json'  
  
<pre><code>.terraformrc</code></pre>  
<pre><code>terraform.rc</code></pre>  
исключаем файлы '.terraformrc' и 'terraform.rc'  
