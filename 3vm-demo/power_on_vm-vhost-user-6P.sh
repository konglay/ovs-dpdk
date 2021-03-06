#!/bin/sh

vm=/root/vm-images/ubuntu-16.04-vpp.img
vm_name=VPP-VM1
vnc=1
echo "ssh 2023"
echo "vnc $vnc"
if [ ! -f $vm ];
then
    echo "VM $vm not found!"
else
    echo "VM $vm started! VNC: $vnc, ssh port: 23"
    taskset -c 3-6,10,12-14,16-19  /root/ovs-dpdk/qemu-2.12.1/x86_64-softmmu/qemu-system-x86_64 -m 8G -smp 12,cores=12,threads=1,sockets=1 -cpu host -drive format=qcow2,file=$vm  -boot c -enable-kvm -name $vm_name \
-object memory-backend-file,id=mem,size=8G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem -mem-prealloc \
-netdev user,id=nttsip,hostfwd=tcp::2023-:22 \
-device e1000,netdev=nttsip \
-chardev socket,id=char1,path=/usr/local/var/run/openvswitch/vhost-user0 \
-netdev type=vhost-user,id=net1,chardev=char1,vhostforce -device virtio-net-pci,netdev=net1,mac=00:01:00:00:00:01,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char2,path=/usr/local/var/run/openvswitch/vhost-user1 \
-netdev type=vhost-user,id=net2,chardev=char2,vhostforce -device virtio-net-pci,netdev=net2,mac=00:02:00:00:00:02,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char3,path=/usr/local/var/run/openvswitch/vhost-user2 \
-netdev type=vhost-user,id=net3,chardev=char3,vhostforce -device virtio-net-pci,netdev=net3,mac=00:03:00:00:00:03,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char4,path=/usr/local/var/run/openvswitch/vhost-user3 \
-netdev type=vhost-user,id=net4,chardev=char4,vhostforce -device virtio-net-pci,netdev=net4,mac=00:04:00:00:00:04,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char5,path=/usr/local/var/run/openvswitch/vhost-user4 \
-netdev type=vhost-user,id=net5,chardev=char5,vhostforce -device virtio-net-pci,netdev=net5,mac=00:05:00:00:00:05,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char6,path=/usr/local/var/run/openvswitch/vhost-user5 \
-netdev type=vhost-user,id=net6,chardev=char6,vhostforce -device virtio-net-pci,netdev=net6,mac=00:06:00:00:00:06,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-vnc :$vnc &
fi
