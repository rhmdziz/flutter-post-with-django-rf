# Generated by Django 4.2.1 on 2023-05-15 00:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_person_photo'),
    ]

    operations = [
        migrations.CreateModel(
            name='Mahasiswa',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nama', models.CharField(max_length=30)),
                ('phone', models.CharField(max_length=30)),
                ('email', models.CharField(max_length=30)),
                ('photo', models.ImageField(upload_to='')),
            ],
        ),
    ]
