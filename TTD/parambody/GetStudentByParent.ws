<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <SelectStudentByParent xmlns="http://tempuri.org/">
      <Username>$(username)</Username>
      <Password>$(password)</Password>
    </SelectStudentByParent>
  </soap12:Body>
</soap12:Envelope>