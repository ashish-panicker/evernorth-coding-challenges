# Spring Core Practice

Create a beanbased on the following class.

```java
class ConnectionSettings {

  private int timeOut;
  private String connectionName;
  private final String connectionUrl;

  // Mandatory Constructor
  // Getters and Setters as needed
}
```

**Tasks**
- Create a Spring bean using xml config
- Provide value to `connectionUrl` as constructor argument
- Provide values to `timeOut` and `connectionName` as properties
- Supply an `init-method` as well

**XML Config File**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
		https://www.springframework.org/schema/beans/spring-beans.xsd">
</beans>
```

**References**
- https://docs.spring.io/spring-framework/reference/core/beans/basics.html
