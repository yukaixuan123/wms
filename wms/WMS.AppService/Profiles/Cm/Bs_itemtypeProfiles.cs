using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity.Cm;

namespace WMS.AppService.Profiles.Cm
{
    public class Bs_itemtypeProfiles:Profile
    {
        public Bs_itemtypeProfiles()
        {
            CreateMap<AddBs_itemtypeDtos, Bs_item_type>().ReverseMap();
            CreateMap<UpdateBs_itemtypeDtos, Bs_item_type>().ReverseMap();
            //CreateMap<DeleteBs_itemtypeDtos, Bs_item_type>().ReverseMap();
        }
    }
}
