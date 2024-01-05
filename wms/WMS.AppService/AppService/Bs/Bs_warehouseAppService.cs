using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Bs;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Repository.Bs;

namespace WMS.AppService.AppService.Bs
{
    public class Bs_warehouseAppService:IBs_warehouseAppService
    {
        private readonly IBs_warehouseRepository bs_WarehouseRepository;
        private readonly IMapper mapper;
        public Bs_warehouseAppService(IBs_warehouseRepository bs_WarehouseRepository, IMapper mapper)
        {
            this.bs_WarehouseRepository = bs_WarehouseRepository;
            this.mapper = mapper;
        }

        public Task<bool> Bs_warehouseAdd(AddBs_warehouseDto addBs_warehouseDto)
        {
            Bs_warehouse bs_Warehouse = mapper.Map<Bs_warehouse>(addBs_warehouseDto);
            return bs_WarehouseRepository.Bs_warehouseAdd(bs_Warehouse);
        }
        /// <summary>
        /// 所有的仓库
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_warehouse>> Bs_warehouseSelect1()
        {
            return bs_WarehouseRepository.Bs_warehouseSelect1();
        }
        public Task<int> Bs_warehouseDel(DelBs_warehouseDto delBs_WarehouseDto)
        {
            Bs_warehouse bs_Warehouse = mapper.Map<Bs_warehouse>(delBs_WarehouseDto);
            return bs_WarehouseRepository.Bs_warehouseDel(bs_Warehouse);
        }

        public IEnumerable<Bs_warehouse> Bs_warehouseFenYe(int page, int pageSize)
        {
            return bs_WarehouseRepository.Bs_warehouseFenYe(page, pageSize);
        }

        public IEnumerable<Bs_warehouse> Bs_WarehousesMH(string bh, string zt, string zg)
        {
            return bs_WarehouseRepository.Bs_WarehousesMH(bh, zt, zg);
        }

        public FenYe<Bs_warehouse> Bs_WarehouseFYMH(int page, int size, string bh, string zt, string zg)
        {
            return bs_WarehouseRepository.Bs_WarehouseFYMH(page, size, bh, zt, zg);
        }

        public Task<List<Bs_warehouse>> Bs_warehouseSelect()
        {
            return bs_WarehouseRepository.Bs_warehouseSelect();
        }

        public Task<bool> Bs_warehouseUpdate(UpdateBs_warehouseDto updateBs_WarehouseDto)
        {
            Bs_warehouse bs_Warehouse = mapper.Map<Bs_warehouse>(updateBs_WarehouseDto);
            return bs_WarehouseRepository.Bs_warehouseUpdate(bs_Warehouse);
        }

        public Task<bool> Bs_WarehouseRKDel(int id, string del)
        {
            return bs_WarehouseRepository.Bs_WarehouseRKDel(id, del);
        }
        public Task<bool> DeleteHouseAsync(int id, string str)
        {
            return bs_WarehouseRepository.DeleteHouseAsync(id, str);
        }

        public Task<FenYeSupply<CKView>> FenYeHouseAsync(int currentPage, int pageSize, string str)
        {
            return bs_WarehouseRepository.FenYeHouseAsync(currentPage, pageSize, str);
        }

        public Task<bool> InsertHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string cz, string gx, string name, string bz, string dh)
        {
            return bs_WarehouseRepository.InsertHouseAsync(code, cap, zt, adr, mr, sd, man, px, cz, gx, name, bz, dh);
        }

        public Task<bool> PLDeleteHouse(int[] num)
        {
            return bs_WarehouseRepository.PLDeleteHouse(num);
        }

        public Task<int> SelectAreaSLAsync(string name)
        {
            return bs_WarehouseRepository.SelectAreaSLAsync(name);
        }

        public Task<Bs_warehouse> SelectIDAsync(int id)
        {
            return bs_WarehouseRepository.SelectIDAsync(id);
        }

        public Task<int> SelectNameAsync(string name)
        {
            return bs_WarehouseRepository.SelectNameAsync(name);
        }

        public Task<bool> UpdateHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string gx, string name, string bz, string dh, int id)
        {
            return bs_WarehouseRepository.UpdateHouseAsync(code, cap, zt, adr, mr, sd, man, px, gx, name, bz, dh, id);
        }

        public Task<bool> UpdateSDAsync()
        {
            return bs_WarehouseRepository.UpdateSDAsync();
        }

        public Task<CKView> SelectCodeAsync(string id)
        {
            return bs_WarehouseRepository.SelectCodeAsync(id);
        }

        public Task<bool> PLQiHouse(int[] num)
        {
            return bs_WarehouseRepository.PLQiHouse(num);
        }

        public Task<bool> PLTingHouse(int[] num)
        {
            return bs_WarehouseRepository.PLTingHouse(num);
        }
    }
}
