1创建polls app，修改py文件
vim model.py
```
from django.db import models

# Create your models here.
def user_directory_path(instance, filename):
    # file will be uploaded to MEDIA_ROOT/user_<id>/<filename>
    return 'uploads/%Y%m%d-{0}'.format(filename)

class FileModel(models.Model):
    title = models.CharField(max_length=50)
    file = models.FileField(upload_to=user_directory_path)
```
2.创建forms.py,加入下面内容：

```
class UploadFileForm(forms.Form):
    my_file = forms.FileField(widget=forms.ClearableFileInput(attrs={'multiple': True}))
```


3. vim views.py，加入下面内容：

```
from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.shortcuts import render
from .forms import UploadFileForm
#from  .from import UploadFileForm
#from .forms import ModelFormWithFileField

# Imaginary function to handle an uploaded file.
#from somewhere import handle_uploaded_file

#import requests
import os

# Create your views here.
import datetime

def handle_uploaded_file(f):
    today = str(datetime.date.today())#获得今天日期
    file_name = today + '_' + f.name#获得上传来的文件名称,加入下划线分开日期和名称
    file_path = os.path.join(os.path.dirname(__file__),'upload_file',file_name)#拼装目录名称+文件名称
    with open(file_path, 'wb+') as destination:
        for chunk in f.chunks():
            destination.write(chunk)


def upload(request):
    if request.method == 'POST':
        form = UploadFileForm(request.POST, request.FILES)
        files = request.FILES.getlist('my_file')
        if form.is_valid():
            for f in files:
                handle_uploaded_file(f)

 #           return HttpResponseRedirect('hangchuanchenggong!')
            return HttpResponse('wenjianshangchuanchenggong')
    else:
        form = UploadFileForm()
    return render(request, 'upload.html', {'form': form})

```

[root@localhost /home/django-cs/mysite] 13:29:22 0
$ ll
total 8
-rw-r--r-- 1 root root    0 Sep 25 14:42 db.sqlite3
-rwxr-xr-x 1 root root  538 Sep 25 14:36 manage.py
drwxr-xr-x 3 root root   88 Sep 25 16:27 mysite
drwxr-xr-x 5 root root 4096 Sep 25 17:44 polls
drwxr-xr-x 2 root root   24 Sep 25 14:37 templates

cd  templates,并且vim  upload.html
```
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>uploadFile</title>
</head>
<body>
    <form method="post" action="" enctype="multipart/form-data">
    {% csrf_token %}
       <label> 上传文件 </label>
        {{ form }}

       <br/>
       <input type="submit" value="upload"/>

    </form>
</body>
</html
```
5. 修改url.py
```
from polls  import views
urlpatterns = [
    path('admin/', admin.site.urls),
    path('upload/', views.upload),
    path('', views.upload),
```


