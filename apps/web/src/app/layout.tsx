import "./globals.css";
import type { ReactNode } from "react";

export const metadata = {
  title: "ClickMe Admin Portal",
  description: "Internal admin portal for ClickMe operations and finance",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
