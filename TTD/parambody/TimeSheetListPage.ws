<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <SelectTutorTimesheetsPage xmlns="http://tempuri.org/">
      <username>$(username)</username>
      <password>$(password)</password>
      <timesheetstatus>T,P,X,A,R,D</timesheetstatus>
      <startPage>$(startPage)</startPage>
      <endPage>$(endPage)</endPage>
    </SelectTutorTimesheetsPage>
  </soap12:Body>
</soap12:Envelope>