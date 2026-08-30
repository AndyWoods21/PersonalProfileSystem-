package za.ac.Servlet;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import za.ac.org.Certification;
import za.ac.org.Education;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.Reference;
import za.ac.org.Skill;
import za.ac.org.User;
import za.ac.org.WorkExperience;

// Direct DAO Imports - Update package paths if your DAOs live elsewhere
import za.ac.DAO.CertificationDAO;
import za.ac.DAO.EducationDAO;
import za.ac.DAO.PersonalInfoDAO;
import za.ac.DAO.ReferenceDAO;
import za.ac.DAO.SkillDAO;
import za.ac.DAO.WorkExperienceDAO;

@WebServlet(name = "GeneratePdfServlet", urlPatterns = {"/GeneratePdfServlet", "/GeneratePdfServlet.do"})
public class GeneratePdfServlet extends HttpServlet {

    // Document Fonts
    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, BaseColor.WHITE);
    private static final Font SUBTITLE_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, new BaseColor(56, 189, 248));
    private static final Font HEADER_CONTACT_FONT = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, new BaseColor(226, 232, 240));
    
    private static final Font SECTION_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, new BaseColor(15, 23, 42));
    private static final Font ITEM_TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, new BaseColor(15, 23, 42));
    private static final Font ITEM_SUBTITLE_FONT = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(100, 116, 139));
    private static final Font ITEM_DATE_FONT = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(2, 132, 199));
    private static final Font NORMAL_FONT = new Font(Font.FontFamily.HELVETICA, 9.5f, Font.NORMAL, new BaseColor(51, 65, 85));
    private static final Font ITALIC_FONT = new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, new BaseColor(100, 116, 139));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ==========================================
        // OPTION A: FETCH DIRECLTY FROM DATABASE DAOS
        // ==========================================
        int userId = currentUser.getUserId(); // Adjust method name if your User model uses getId()

        PersonalInfoDAO personalInfoDao = new PersonalInfoDAO();
        WorkExperienceDAO workDao = new WorkExperienceDAO();
        EducationDAO eduDao = new EducationDAO();
        SkillDAO skillDao = new SkillDAO();
        CertificationDAO certDao = new CertificationDAO();
        ReferenceDAO refDao = new ReferenceDAO();

        PersonalInfoEntity profile = personalInfoDao.getPersonalInfoByUserId(userId);
        List<WorkExperience> workList = workDao.getWorkExperienceByUserId(userId);
        List<Education> eduList = eduDao.getEducationByUserId(userId);
        List<Skill> skillList = skillDao.getSkillsByUserId(userId);
        List<Certification> certList = certDao.getCertificationsByUserId(userId);
        List<Reference> refList = refDao.getReferencesByUserId(userId);

        // Personal Information fallback handling
        String fullname = (profile != null && profile.getFullname() != null && !profile.getFullname().isEmpty()) ? profile.getFullname() : currentUser.getUsername();
        String jobTitle = (profile != null && profile.getJobTitle() != null) ? profile.getJobTitle() : "Professional Candidate";
        String email = (profile != null && profile.getEmail() != null) ? profile.getEmail() : "N/A";
        String phone = (profile != null && profile.getPhone() != null) ? profile.getPhone() : "N/A";
        String location = (profile != null && profile.getLocation() != null) ? profile.getLocation() : "N/A";
        String website = (profile != null && profile.getWebsiteUrl() != null) ? profile.getWebsiteUrl() : null;
        String github = (profile != null && profile.getGithubUrl() != null) ? profile.getGithubUrl() : null;
        String linkedin = (profile != null && profile.getLinkedinUrl() != null) ? profile.getLinkedinUrl() : null;
        String summary = (profile != null && profile.getProfessionalSummary() != null) ? profile.getProfessionalSummary() : null;

        response.setContentType("application/pdf");
        String fileName = fullname.replaceAll("\\s+", "_") + "_CV.pdf";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        Document document = new Document(PageSize.A4, 36, 36, 36, 36);

        try (OutputStream out = response.getOutputStream()) {
            PdfWriter.getInstance(document, out);
            document.open();

            // ==========================================
            // 1. HEADER BANNER SECTION
            // ==========================================
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.setWidthPercentage(100);
            headerTable.setWidths(new float[]{55f, 45f});

            // Name & Subtitle Cell
            PdfPCell leftHeaderCell = new PdfPCell();
            leftHeaderCell.setBackgroundColor(new BaseColor(15, 23, 42)); // Dark Navy
            leftHeaderCell.setPadding(16);
            leftHeaderCell.setBorder(PdfPCell.NO_BORDER);
            leftHeaderCell.addElement(new Paragraph(fullname, TITLE_FONT));
            leftHeaderCell.addElement(new Paragraph(jobTitle.toUpperCase(), SUBTITLE_FONT));

            // Contact Info Cell
            PdfPCell rightHeaderCell = new PdfPCell();
            rightHeaderCell.setBackgroundColor(new BaseColor(15, 23, 42));
            rightHeaderCell.setPadding(16);
            rightHeaderCell.setBorder(PdfPCell.NO_BORDER);
            rightHeaderCell.setHorizontalAlignment(Element.ALIGN_RIGHT);

            Paragraph contactPara = new Paragraph();
            contactPara.setAlignment(Element.ALIGN_RIGHT);
            contactPara.add(new Phrase("Email: " + email + "\n", HEADER_CONTACT_FONT));
            contactPara.add(new Phrase("Phone: " + phone + "\n", HEADER_CONTACT_FONT));
            contactPara.add(new Phrase("Location: " + location + "\n", HEADER_CONTACT_FONT));
            
            if (website != null && !website.trim().isEmpty()) {
                contactPara.add(new Phrase("Website: " + website + "\n", HEADER_CONTACT_FONT));
            }
            if (github != null && !github.trim().isEmpty()) {
                contactPara.add(new Phrase("GitHub: " + github + "\n", HEADER_CONTACT_FONT));
            }
            if (linkedin != null && !linkedin.trim().isEmpty()) {
                contactPara.add(new Phrase("LinkedIn: " + linkedin + "\n", HEADER_CONTACT_FONT));
            }
            rightHeaderCell.addElement(contactPara);

            headerTable.addCell(leftHeaderCell);
            headerTable.addCell(rightHeaderCell);
            document.add(headerTable);

            addSpacer(document, 10);

            // ==========================================
            // 2. PROFESSIONAL SUMMARY
            // ==========================================
            if (summary != null && !summary.trim().isEmpty()) {
                addSectionHeader(document, "PROFESSIONAL SUMMARY");
                document.add(new Paragraph(summary, NORMAL_FONT));
                addSpacer(document, 12);
            }

            // ==========================================
            // 3. WORK EXPERIENCE
            // ==========================================
            if (workList != null && !workList.isEmpty()) {
                addSectionHeader(document, "WORK EXPERIENCE");
                for (WorkExperience work : workList) {
                    PdfPTable expTable = new PdfPTable(2);
                    expTable.setWidthPercentage(100);
                    expTable.setWidths(new float[]{70f, 30f});

                    String roleStr = (work.getJobTitle() != null) ? work.getJobTitle() : "Position";
                    String companyStr = (work.getCompanyName() != null) ? work.getCompanyName() : "Company";
                    String dateStr = (work.getStartDate() != null ? work.getStartDate() : "") + " - " + 
                                     (work.getEndDate() != null && !work.getEndDate().isEmpty() ? work.getEndDate() : "Present");

                    PdfPCell titleCell = new PdfPCell();
                    titleCell.setBorder(PdfPCell.NO_BORDER);
                    titleCell.addElement(new Paragraph(roleStr, ITEM_TITLE_FONT));
                    titleCell.addElement(new Paragraph(companyStr, ITEM_SUBTITLE_FONT));

                    PdfPCell dateCell = new PdfPCell();
                    dateCell.setBorder(PdfPCell.NO_BORDER);
                    Paragraph dPara = new Paragraph(dateStr, ITEM_DATE_FONT);
                    dPara.setAlignment(Element.ALIGN_RIGHT);
                    dateCell.addElement(dPara);

                    expTable.addCell(titleCell);
                    expTable.addCell(dateCell);
                    document.add(expTable);

                    if (work.getDescription() != null && !work.getDescription().trim().isEmpty()) {
                        Paragraph descPara = new Paragraph(work.getDescription(), NORMAL_FONT);
                        descPara.setSpacingBefore(3);
                        document.add(descPara);
                    }
                    addSpacer(document, 8);
                }
                addSpacer(document, 6);
            }

            // ==========================================
            // 4. EDUCATION
            // ==========================================
            if (eduList != null && !eduList.isEmpty()) {
                addSectionHeader(document, "EDUCATION");
                for (Education edu : eduList) {
                    PdfPTable eduTable = new PdfPTable(2);
                    eduTable.setWidthPercentage(100);
                    eduTable.setWidths(new float[]{70f, 30f});

                    String degreeStr = (edu.getDegree() != null) ? edu.getDegree() : "Degree";
                    if (edu.getFieldOfStudy() != null && !edu.getFieldOfStudy().isEmpty()) {
                        degreeStr += " in " + edu.getFieldOfStudy();
                    }
                    String instStr = (edu.getInstitutionName() != null) ? edu.getInstitutionName() : "Institution";
                    String eduDateStr = (edu.getStartDate() != null ? edu.getStartDate() : "") + " - " + 
                                        (edu.getEndDate() != null ? edu.getEndDate() : "");

                    PdfPCell titleCell = new PdfPCell();
                    titleCell.setBorder(PdfPCell.NO_BORDER);
                    titleCell.addElement(new Paragraph(degreeStr, ITEM_TITLE_FONT));
                    titleCell.addElement(new Paragraph(instStr, ITEM_SUBTITLE_FONT));

                    PdfPCell dateCell = new PdfPCell();
                    dateCell.setBorder(PdfPCell.NO_BORDER);
                    Paragraph dPara = new Paragraph(eduDateStr, ITEM_DATE_FONT);
                    dPara.setAlignment(Element.ALIGN_RIGHT);
                    dateCell.addElement(dPara);

                    eduTable.addCell(titleCell);
                    eduTable.addCell(dateCell);
                    document.add(eduTable);
                    addSpacer(document, 6);
                }
                addSpacer(document, 6);
            }

            // ==========================================
            // 5. SKILLS & CERTIFICATIONS (2-COLUMN GRID)
            // ==========================================
            if ((skillList != null && !skillList.isEmpty()) || (certList != null && !certList.isEmpty())) {
                PdfPTable twoColTable = new PdfPTable(2);
                twoColTable.setWidthPercentage(100);
                twoColTable.setWidths(new float[]{50f, 50f});

                // --- Skills Column ---
                PdfPCell skillsCell = new PdfPCell();
                skillsCell.setBorder(PdfPCell.NO_BORDER);
                skillsCell.setPaddingRight(10);
                
                if (skillList != null && !skillList.isEmpty()) {
                    skillsCell.addElement(createSectionTitleParagraph("SKILLS"));
                    for (Skill skill : skillList) {
                        String sName = (skill.getSkillName() != null) ? skill.getSkillName() : "Skill";
                        String sCat = (skill.getCategory() != null && !skill.getCategory().trim().isEmpty()) ? " [" + skill.getCategory() + "]" : "";
                        String sLevel = (skill.getProficiencyLevel() != null && !skill.getProficiencyLevel().trim().isEmpty()) ? " (" + skill.getProficiencyLevel() + ")" : "";
                        
                        Paragraph p = new Paragraph("• " + sName + sCat + sLevel, NORMAL_FONT);
                        p.setSpacingAfter(2);
                        skillsCell.addElement(p);
                    }
                }

                // --- Certifications Column ---
                PdfPCell certsCell = new PdfPCell();
                certsCell.setBorder(PdfPCell.NO_BORDER);
                certsCell.setPaddingLeft(10);

                if (certList != null && !certList.isEmpty()) {
                    certsCell.addElement(createSectionTitleParagraph("CERTIFICATIONS"));
                    for (Certification cert : certList) {
                        String cTitle = (cert.getTitle() != null) ? cert.getTitle() : "Certification";
                        String cOrg = (cert.getIssuingOrganization() != null) ? cert.getIssuingOrganization() : "";
                        String cDate = (cert.getIssueDate() != null && !cert.getIssueDate().isEmpty()) ? " (" + cert.getIssueDate() + ")" : "";
                        String cUrl = (cert.getCredentialUrl() != null && !cert.getCredentialUrl().isEmpty()) ? cert.getCredentialUrl() : null;

                        Paragraph p = new Paragraph(cTitle, ITEM_TITLE_FONT);
                        Paragraph sub = new Paragraph(cOrg + cDate, ITEM_SUBTITLE_FONT);
                        
                        certsCell.addElement(p);
                        certsCell.addElement(sub);
                        
                        if (cUrl != null) {
                            Paragraph urlPara = new Paragraph("URL: " + cUrl, NORMAL_FONT);
                            certsCell.addElement(urlPara);
                        }
                        
                        Paragraph spacer = new Paragraph(" ");
                        spacer.setSpacingAfter(4);
                        certsCell.addElement(spacer);
                    }
                }

                twoColTable.addCell(skillsCell);
                twoColTable.addCell(certsCell);
                document.add(twoColTable);
                addSpacer(document, 10);
            }

            // ==========================================
            // 6. REFERENCES
            // ==========================================
            if (refList != null && !refList.isEmpty()) {
                addSectionHeader(document, "REFERENCES");
                PdfPTable refTable = new PdfPTable(2);
                refTable.setWidthPercentage(100);
                refTable.setWidths(new float[]{50f, 50f});

                for (Reference ref : refList) {
                    PdfPCell cell = new PdfPCell();
                    cell.setBorder(PdfPCell.NO_BORDER);
                    cell.setPaddingBottom(8);

                    String rName = (ref.getName() != null) ? ref.getName() : "Reference";
                    String rJob = (ref.getJobTitle() != null) ? ref.getJobTitle() : "";
                    String rCompany = (ref.getCompany() != null && !ref.getCompany().isEmpty()) ? " @ " + ref.getCompany() : "";
                    String rEmail = (ref.getEmail() != null) ? ref.getEmail() : "";

                    cell.addElement(new Paragraph(rName, ITEM_TITLE_FONT));
                    cell.addElement(new Paragraph(rJob + rCompany, ITEM_SUBTITLE_FONT));
                    if (!rEmail.isEmpty()) {
                        cell.addElement(new Paragraph(rEmail, NORMAL_FONT));
                    }
                    if (ref.getTestimonial() != null && !ref.getTestimonial().isEmpty()) {
                        cell.addElement(new Paragraph("\"" + ref.getTestimonial() + "\"", ITALIC_FONT));
                    }
                    refTable.addCell(cell);
                }

                // Balance odd number of reference cells
                if (refList.size() % 2 != 0) {
                    PdfPCell emptyCell = new PdfPCell();
                    emptyCell.setBorder(PdfPCell.NO_BORDER);
                    refTable.addCell(emptyCell);
                }

                document.add(refTable);
            }

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF document.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Helper method to write styled section headers
    private void addSectionHeader(Document document, String title) throws Exception {
        document.add(createSectionTitleParagraph(title));
    }

    private Paragraph createSectionTitleParagraph(String title) {
        Paragraph p = new Paragraph(title, SECTION_FONT);
        p.setSpacingBefore(8);
        p.setSpacingAfter(4);
        
        // Adds an underline line beneath section headings
        PdfPTable lineTable = new PdfPTable(1);
        lineTable.setWidthPercentage(100);
        PdfPCell lineCell = new PdfPCell();
        lineCell.setFixedHeight(1.5f);
        lineCell.setBackgroundColor(new BaseColor(2, 132, 199)); // Sky Blue Line
        lineCell.setBorder(PdfPCell.NO_BORDER);
        lineTable.addCell(lineCell);
        
        p.add(lineTable);
        return p;
    }

    // Helper method for consistent document vertical spacing
    private void addSpacer(Document document, float space) throws Exception {
        Paragraph spacer = new Paragraph(" ");
        spacer.setSpacingBefore(space);
        document.add(spacer);
    }
}
