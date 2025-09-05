const express = require("express");
const { SerialPort } = require("serialport");
const { ReadlineParser } = require("@serialport/parser-readline");

const app = express();
app.use(express.json());
app.use(express.static("public"));

const PORT = 3000;
const UART_PATH = "/dev/ttyAMA0";
const BAUD_RATE = 9600;

//UART設定
const uart = new SerialPort({ path: UART_PATH, baudRate: BAUD_RATE });
const parser = uart.pipe(new ReadlineParser({ delimiter: "\r\n" }));

let latestData;

//uart受信
parser.on("data", (data) => {
  console.log("UART Received:", data);
  latestData = data;
});

//uart送信
app.post("/send", (req, res) => {
  const { msg } = req.body;
  if (msg) {
    uart.write(msg + "\n");
    res.json({ status: true });
  } else {
    res.status(400).json({ status: "error", message: "No msg provided" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
