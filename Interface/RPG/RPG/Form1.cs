using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace RPG
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void label6_Click(object sender, EventArgs e)
        {

        }
        NpgsqlConnection connection = new NpgsqlConnection("server=localHost; port=5432; Database=RPGAssignmentDBSM; user Id=postgres; password=123456");
        private void btnList_Click(object sender, EventArgs e)
        {
            string sorgu = "select * from characterlist";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, connection);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void btnInsert_Click(object sender, EventArgs e)
        {
            connection.Open();
            NpgsqlCommand command1 = new NpgsqlCommand("insert into character (characterid,name,age,country,race," +
                "class,equipment,ability) values (@p1,@p2,@p3,@p4,@p5,@p6,@p7,@p8)",connection);
            command1.Parameters.AddWithValue("@p1", int.Parse(txtId.Text));
            command1.Parameters.AddWithValue("@p2",txtName.Text);
            command1.Parameters.AddWithValue("@p3", int.Parse(txtAge.Text));
            command1.Parameters.AddWithValue("@p4", txtCountry.Text);
            command1.Parameters.AddWithValue("@p5", int.Parse(txtClass.Text));
            command1.Parameters.AddWithValue("@p6", int.Parse(txtRace.Text));
            command1.Parameters.AddWithValue("@p7", int.Parse(txtEquipment.Text));
            command1.Parameters.AddWithValue("@p8", int.Parse(txtAbility.Text));
            command1.ExecuteNonQuery();
            connection.Close();
            MessageBox.Show("Character successfully created.");

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            connection.Open();
            NpgsqlCommand command2 = new NpgsqlCommand("Delete from character where characterid=@p1", connection);
            command2.Parameters.AddWithValue("@p1", int.Parse(txtId.Text));
            command2.ExecuteNonQuery();
            connection.Close();
            MessageBox.Show("Character has been successfully deleted.");
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            connection.Open();
            NpgsqlCommand command3 = new NpgsqlCommand("update character set name=@p2,age=@p3,country=@p4,race=@p6,class=@p5," +
                "equipment=@p7, ability=@p8 where characterid=@p1", connection);
            command3.Parameters.AddWithValue("@p1", int.Parse(txtId.Text));
            command3.Parameters.AddWithValue("@p2", txtName.Text);
            command3.Parameters.AddWithValue("@p3", int.Parse(txtAge.Text));
            command3.Parameters.AddWithValue("@p4", txtCountry.Text);
            command3.Parameters.AddWithValue("@p5", int.Parse(txtClass.Text));
            command3.Parameters.AddWithValue("@p6", int.Parse(txtRace.Text));
            command3.Parameters.AddWithValue("@p7", int.Parse(txtEquipment.Text));
            command3.Parameters.AddWithValue("@p8", int.Parse(txtAbility.Text));
            command3.ExecuteNonQuery();
            connection.Close();
            MessageBox.Show("Character has been successfully updated.");
        }

        private void btnView_Click(object sender, EventArgs e)
        {
            connection.Open();
            NpgsqlCommand command4 = new NpgsqlCommand("select * from characterlist", connection);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(command4);
            DataSet dt = new DataSet();
            da.Fill(dt);
            dataGridView1.DataSource = dt.Tables[0];
            connection.Close();
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            connection.Open();
            NpgsqlCommand command5 = new NpgsqlCommand("select * from characterlist where characterid=@p1", connection);
            command5.Parameters.AddWithValue("@p1", int.Parse(txtSearch.Text));
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(command5);
            DataTable dt = new DataTable();
            da.Fill(dt);
            dataGridView1.DataSource = dt;
            connection.Close();
        }

        private void txtSearch_TextChanged(object sender, EventArgs e)
        {
          

           
        }
    }
}
