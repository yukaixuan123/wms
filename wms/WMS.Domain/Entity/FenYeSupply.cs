using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity
{
    public class FenYeSupply<T>
    {
        public int Rows { get; set; }
        public int CurrentPage { get; set; }
        public int PageSize { get; set; }

        public IEnumerable<T> List { get; set; }

    }
}
