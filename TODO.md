# PDF Colors Update - AppColors Integration Plan

## Approved Plan Steps (User Confirmed)

✅ **Step 1**: Create this TODO.md to track progress.

**Next Steps** (to be marked as completed progressively):

**Step 2**: Add PDF color constants directly in AppointmentPdfService class using PdfColor.fromInt():
```
static const pw.PdfColor primaryColor = pw.PdfColor.fromInt(0xFF2BB7AE);
static const pw.PdfColor primaryLightColor = pw.PdfColor.fromInt(0xFF0BFBEB);
static const pw.PdfColor grayColor = pw.PdfColor.fromInt(0xFF393939);
static const pw.PdfColor blackColor = pw.PdfColor.fromInt(0xFF000000);
static const pw.PdfColor whiteColor = pw.PdfColor.fromInt(0xFFFFFFFF);
static const pw.PdfColor grayLight2Color = pw.PdfColor.fromInt(0xFFE6E6E6);
static const pw.PdfColor subtlePrimary = pw.PdfColor.fromInt(0x1A0BFBEB); // ~10% opacity
```

**Step 3**: Update Header Container decoration and texts.

**Step 4**: Update all Section Header texts (Patient/Doctor/Appointment).

**Step 5**: Update _buildInfoRow label and value colors.

**Step 6**: Update Footer Container and texts.

**Step 7**: Verify no errors, test PDF generation, mark complete, and showcase.

## Color Mapping
- Headers/Titles: primaryColor (#2BB7AE)
- Labels: grayColor (#393939)
- Values: blackColor (#000000)
- Backgrounds: grayLight2Color (#E6E6E6)
- Accents: primaryLightColor (#0BFBEB)
- Subtle bg: subtlePrimary (low opacity)

**File**: lib/core/bdf_send/appointment_pdf_service.dart

