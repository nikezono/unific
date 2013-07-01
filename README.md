newstream
---

ストリーム系RSSリーダー

---


## 処理のながれ

Http Request      -> app.routes(config/routes) -> each events
Websocket Request -> io(config/io) -> ioRoutes(config/ioRoutes) -> each events