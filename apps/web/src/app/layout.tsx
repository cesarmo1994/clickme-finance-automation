import "./globals.css";

export const metadata = {
  title: "ClickMe Admin Portal",
  description: "Internal admin portal for ClickMe operations and finance",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
