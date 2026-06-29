import React from "react";
import ReactDOM from "react-dom/client";

function App() {
  return (
    <main
      style={{
        fontFamily: "Segoe UI, PingFang SC, sans-serif",
        margin: 0,
        minHeight: "100vh",
        background: "linear-gradient(180deg, #0f172a, #1e293b)",
        color: "#f8fafc",
      }}
    >
      <div style={{ maxWidth: 420, margin: "0 auto", padding: 24 }}>
        <div
          style={{
            padding: 24,
            borderRadius: 28,
            background: "rgba(255,255,255,0.08)",
            boxShadow: "0 20px 50px rgba(0,0,0,0.18)",
            backdropFilter: "blur(10px)",
          }}
        >
          <h1 style={{ marginTop: 0 }}>Omni Platform Mobile</h1>
          <p style={{ lineHeight: 1.8, color: "#cbd5e1" }}>
            这是正式平台母版的移动端基础壳。后续派生时可替换为 H5、UniApp、小程序或 React Native 对应实现。
          </p>
          <ul style={{ lineHeight: 1.9, paddingLeft: 20 }}>
            <li>保留独立目录，不与后台混仓</li>
            <li>承接用户侧首页、消息、个人中心等能力</li>
            <li>适合作为未来移动端模板入口</li>
          </ul>
        </div>
      </div>
    </main>
  );
}

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
