using DevExpress.XtraReports.UI;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QL_SV.Report
{
    public partial class Frpt_DsThiHetMon : Form
    {
        public Frpt_DsThiHetMon()
        {
            InitializeComponent();
        }

        private void Frpt_PhieuDiemThi_Load(object sender, EventArgs e)
        {
            DS.EnforceConstraints = false;
            this.mONHOCTableAdapter.Fill(this.DS.MONHOC);
            this.lOPTableAdapter.Fill(this.DS.LOP);
            if (Program.mGroup == "PGV")
            {
                Program.servername = @"VTN\VTN";
                Program.mlogin = Program.remotelogin;
                Program.password = Program.remotepassword;
            }
            if (Program.mGroup == "KHOA" && Program.mKhoa == 0)
            {
                Program.servername = @"VTN\VTN1";
            }
            if (Program.mGroup == "KHOA" && Program.mKhoa == 2)
            {
                Program.servername = @"VTN\VTN2";
            }
            if (Program.KetNoi() == 0)
                MessageBox.Show("Lỗi kết nối về Khoa mới", "", MessageBoxButtons.OK);
            else
            {
                this.lOPTableAdapter.Connection.ConnectionString = Program.connstr;
                this.lOPTableAdapter.Fill(this.DS.LOP);
                cmbTenLop.DataSource = bdsLOP;  // sao chép bds_dspm đã load ở form đăng nhập  qua
                cmbTenLop.DisplayMember = "TENLOP";
                cmbTenLop.ValueMember = "MALOP";
            }

            txtMaLop.Text = cmbTenLop.SelectedValue.ToString();
            txtMaMon.Text = cmbTenMon.SelectedValue.ToString();
            cmbLanThi.SelectedIndex = 0;
            dtpNgayThi.Format = DateTimePickerFormat.Custom;
            dtpNgayThi.CustomFormat = "dd-MM-yyyy";
        }

        private void cmbTenLop_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmbTenLop.SelectedValue != null)
            {
                txtMaLop.Text = cmbTenLop.SelectedValue.ToString();
            }
        }

        private void cmbTenMon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmbTenMon.SelectedValue != null)
            {
                txtMaMon.Text = cmbTenMon.SelectedValue.ToString();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnIn_Click(object sender, EventArgs e)
        {
            String malop = cmbTenLop.SelectedValue.ToString();
            String mamonhoc = cmbTenMon.SelectedValue.ToString();
          
            Xrpt_DsThiHetMon rpt = new Xrpt_DsThiHetMon(malop);
            rpt.lblLop.Text = cmbTenLop.Text;   
            rpt.lblMonHoc.Text = cmbTenMon.Text;
            rpt.lblNgayThi.Text = dtpNgayThi.Text;
            rpt.CreateDocument();
            documentViewer1.DocumentSource = rpt;
        }
    }
}
