import express from "express";

export const app = express();

app.use(express.json());

// API 36 trong docs/api.md
app.get("/api/health", (req, res) => {
  res.json({ status: "ok" });
});

// Đường dẫn không tồn tại: trả lỗi đúng dạng quy ước ở mục 1.4
app.use((req, res) => {
  res.status(404).json({
    error: { code: "NOT_FOUND", message: "Không tìm thấy đường dẫn" },
  });
});
