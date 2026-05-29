export type InvoiceRow = {
  invoice_key: number;
  invoice_number: string | null;
  vendor_key: number;
  currency_code: string | null;
  recognized_amount: number | null;
  open_amount: number | null;
  total_amount?: number | null;
  processing_status?: string | null;
  needs_review: boolean;
  is_overdue?: boolean;
};

export type VendorRow = {
  vendor_key: number;
  vendor_name: string;
  normalized_vendor_name: string;
  tax_id: string | null;
  primary_email: string | null;
  country_code: string | null;
  default_currency_code: string | null;
  procurement_status: string | null;
  risk_level: string | null;
};

export async function fetchApi<T>(path: string, fallback: T): Promise<T> {
  const baseUrl = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000";

  try {
    const response = await fetch(`${baseUrl}${path}`, { cache: "no-store" });

    if (!response.ok) {
      return fallback;
    }

    return response.json();
  } catch {
    return fallback;
  }
}

export function formatAmount(value: number | null | undefined) {
  return new Intl.NumberFormat("en-US", {
    maximumFractionDigits: 2,
    minimumFractionDigits: 2,
  }).format(value ?? 0);
}
