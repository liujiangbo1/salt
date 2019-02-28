from django import forms
from django.forms import fields
class BlogForm(forms.Form):
    name=forms.CharField(max_length=15)
class DiyForm(forms.Form):
    user = fields.CharField(
        max_length=18,
        min_length=10,
        required=True,
        error_messages={
            'max_length':'too long',
            'min_length':'too short',
            'required':'user can not be empty', 
            'invalid':'type is not right'
}
)
class SaltID(forms.Form):
    ID_Name = fields.CharField(
        label='salt_minion_id',
        max_length=39   
)

