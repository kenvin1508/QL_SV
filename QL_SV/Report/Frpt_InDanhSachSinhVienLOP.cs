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
    public partial class Frpt_InDanhSachSinhVienLOP : Form
    {
        public Frpt_InDanhSachSinhVienLOP()
        {
            InitializeComponent();
        }

        private void Frpt_InDanhSachSinhVienLOP_Load(object sender, EventArgs e)
        {
            DS.EnforceConstraints = false;
            this.lOPTableAdapter.Fill(this.DS.LOP);
            txtMaLop.Text = cmbTenLop.SelectedValue.ToString();
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
                    MessageBox.Show("Lỗi kết nối về chi nhánh mới", "", MessageBoxButtons.OK);
                else
                {
                    this.lOPTableAdapter.Connection.ConnectionString = Program.connstr;
                    this.lOPTableAdapter.Fill(this.DS.LOP);
                    cmbTenLop.DataSource = bdsLOP;  // sao chép bds_dspm đã load ở form đăng nhập  qua
                    cmbTenLop.DisplayMember = "TENLOP";
                    cmbTenLop.ValueMember = "MALOP";
                }
            
        }

        private void btnIn_Click(object sender, EventArgs e)
        {
            Xrpt_InDanhSachSinhVienLOP rpt = new Xrpt_InDanhSachSinhVienLOP(cmbTenLop.SelectedValue.ToString());
            rpt.lblTenLop.Text = cmbTenLop.Text;
            rpt.CreateDocument();
            documentViewer1.DocumentSource = rpt;
        }

        private void cmbTenLop_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmbTenLop.SelectedValue != null)
            {
                txtMaLop.Text = cmbTenLop.SelectedValue.ToString();

            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
