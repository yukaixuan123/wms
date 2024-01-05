using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 调拨单表
    /// </summary>
    public class Wh_transfer_h
    {
        public int transfer_h_id{ get; set; }
        public string transfer_code { get; set; }
        public DateTime transfer_date { get; set; }
        public string out_warecode { get; set; }
        public string in_warecode { get; set; }
        public string sure_state { get; set; }
        public string transfer_type { get; set; }
        public string outware_state { get; set; }
        public string inware_state { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string remark { get; set; }
    }
}
