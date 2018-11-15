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
    public partial class Frpt_PhieuDiemSV : Form
    {
        public Frpt_PhieuDiemSV()
        {
            InitializeComponent();

        }
        private void Frpt_PhieuDiemSV_Load(object sender, EventArgs e)
        {
            DS.EnforceConstraints = false;
            this.dIEMTableAdapter.Fill(this.DS.DIEM);        
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
                this.dIEMTableAdapter.Connection.ConnectionString = Program.connstr;
                this.dIEMTableAdapter.Fill(this.DS.DIEM);
            }
        }
        private void btnIn_Click(object sender, EventArgs e)
        {
            if (txtMaSV.Text.Equals(""))
            {
                MessageBox.Show("Mã sinh viên rỗng !!!");
                return;
            }
            Xrpt_PhieuDiemSV rpt = new Xrpt_PhieuDiemSV(txtMaSV.Text);
            try
            {
                string strLenh = "EXEC sp_GetInfoSV_Report_PDSV '" + txtMaSV.Text + "'";
                Program.myReader = Program.ExecSqlDataReader(strLenh);
                if (Program.myReader == null) return;
                Program.myReader.Read();

                rpt.lblHoTen.Text = Program.myReader.GetString(0);
                rpt.lblLop.Text = Program.myReader.GetString(2);
                Program.myReader.Close();
                rpt.CreateDocument();
                documentViewer1.DocumentSource = rpt;
            }
            catch(Exception ex)
            {
                MessageBox.Show("Không tìm thấy dữ liệu, xem lại mã sinh viên đã nhập \n " +ex.Message, "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                Program.myReader.Close();
            }

           
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void dIEMBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.bdsDIEM.EndEdit();
            this.tableAdapterManager.UpdateAll(this.DS);

        }
    }
}
