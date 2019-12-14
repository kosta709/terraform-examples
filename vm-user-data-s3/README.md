## Instance with userdata from s3 object

From https://www.terraform.io/docs/providers/aws/d/s3_bucket_object.html :  

Note: The content of an object (body field) is available only for objects which have a human-readable Content-Type (text/* and application/json). This is to prevent printing unsafe characters and potentially downloading large amount of data which would be thrown away in favour of metadata

So must set content-type=text/plain 

```
aws s3 cp --content-type=text/plain ./userdata.sh s3://mybucket/path-to/userdata.sh
```