using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    /// <summary>
    /// 库存查询
    /// </summary>
    public class Inventory
    {
        //item_code, item_name, inbill_state, item_type_name, model_code, unit, ware_code, area_code, inbill3_num, jin, ky, kyjin, ru, cu
        public string item_code { get; set; }
        public int now_storage_id { get; set; }
        public string item_name { get; set; }
        public string inbill_state { get; set; }
        public string item_type_name { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string ware_code { get; set; }
        public string area_code { get; set; }
        public decimal inbill3_num { get; set; }
        public decimal jin { get; set; }
        public decimal ky { get; set; }
        public decimal kyjin { get; set; }
        public decimal ru { get; set; }
        public decimal cu { get; set; }
    }
}
