using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    /// <summary>
    /// 调拨
    /// </summary>
    public class ST33
    {
        public int transfer_h_id { get; set; }
        public string transfer_code { get; set; }
        public string out_warecode { get; set; }
        public string in_warecode { get; set; }
        public string transfer_type { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public DateTime transfer_date { get; set; }
        public Decimal total_buy_num { get; set; }
        public Decimal total_price { get; set; }
       
        public string names { get; set; }
     
        public string sure_state { get; set; }
        public string outware_state { get; set; }
        public string inware_state { get; set; }
       

    }
}
