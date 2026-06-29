import React from "react";
import ReactDOM from "react-dom/client";

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || "http://127.0.0.1:7060";

function App() {
  return (
    <main
      style={{
        fontFamily: "Segoe UI, PingFang SC, sans-serif",
        padding: 32,
        minHeight: "100vh",
        background: "#f8fafc",
        color: "#0f172a",
      }}
    >
      <div style={{ maxWidth: 960, margin: "0 auto" }}>
        <h1 style={{ marginBottom: 8 }}>Omni Platform Front</h1>
        <p style={{ color: "#475569", lineHeight: 1.7 }}>
          这是正式平台母版的管理后台基础壳。后续派生新项目时，优先替换品牌、菜单、权限和业务工作台。
        </p>
        <section
          style={{
            marginTop: 24,
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
            gap: 16,
          }}
        >
          <article style={cardStyle}>
            <strong>子项目角色</strong>
            <p style={pStyle}>承接 PC 管理后台、运营工作台、系统配置等平台能力。</p>
          </article>
          <article style={cardStyle}>
            <strong>默认 API 地址</strong>
            <p style={pStyle}>{apiBaseUrl}</p>
          </article>
          <article style={cardStyle}>
            <strong>推荐派生方向</strong>
            <p style={pStyle}>后台首页、菜单框架、权限中心、业务管理页。</p>
          </article>
        </section>
      </div>
    </main>
  );
}

const cardStyle: React.CSSProperties = {
  background: "#ffffff",
  borderRadius: 16,
  padding: 20,
  border: "1px solid #e2e8f0",
  boxShadow: "0 8px 24px rgba(15, 23, 42, 0.04)",
};

const pStyle: React.CSSProperties = {
  marginTop: 10,
  color: "#475569",
  lineHeight: 1.7,
};

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
