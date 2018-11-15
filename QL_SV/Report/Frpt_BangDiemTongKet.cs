using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace QL_SV.Report
{
    public partial class Frpt_BangDiemTongKet : Form
    {
        public Frpt_BangDiemTongKet()
        {
            InitializeComponent();
        }

        private void Frpt_BangDiemTongKet_Load(object sender, EventArgs e)
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

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnIn_Click(object sender, EventArgs e)
        {
            Xrpt_BangDiemTongKet rpt = new Xrpt_BangDiemTongKet(cmbTenLop.SelectedValue.ToString());
            rpt.lblLOP.Text = cmbTenLop.Text;
            MessageBox.Show(rpt.xrPivotGrid1.ActualWidth + " " + rpt.xrPivotGrid1.WidthF);
            int width=rpt.xrPivotGrid1.ActualWidth; // get width of PivotGrid
            int widthMainPage= width + 230; 
            rpt.PageWidth = widthMainPage; // set width for Main Page
            rpt.xrLine1.WidthF = widthMainPage-200; // set width for Line
            MessageBox.Show(rpt.PageWidth+" " + rpt.xrLine1.WidthF);
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
    }
}
